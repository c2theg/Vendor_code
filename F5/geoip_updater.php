<?php
/*
 ------ STEPS -----
 By: Christopher Gray - 9/16/17 - Version 0.0.7
 
 you need PHP to get this to work.
 - For Ubuntu:
 
 sudo LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php
 sudo apt-get -y install php7.0 php7.0-common php7.0-cli php7.0-curl php7.0-mcrypt php-ssh2 php-zip
 
 then just issue on the CLI:
 php geoip_updater.php <downloads.f5.com https geoip file url - on location page> <optional, md5 file url>
 
 */

	error_reporting(E_ALL);
	ini_set("display_errors",1);
	ini_set('error_reporting', E_ALL);
	date_default_timezone_set('America/New_York');
	set_time_limit(3600);
	ini_set("memory_limit","1024M");
	ini_set("precision", "16");
	$Debug = 0;
	//-----------------------------------------------------------------------------------------------------------------
	$BigIPs_ip_array = array(
	   "10.1.1.1", "10.1.1.2"
	);
	$BigIPs_fqdn_array = array(
	   "ltm1.example.com", "ltm2.example.com"
	);
	
	$BigIPs_username = "root";
	$BigIPs_password = "ChangeMe";
	$BigIPs_port = "22";

	
	if (isset($argv[1])) { $F5_DownloadURL = $argv[1]; } else { CLI_Help(); }
	if (isset($argv[2])) { 
	    if (filter_var($argv[2], FILTER_VALIDATE_URL)) {
	       $F5_DownloadURL_MD5 = $argv[2];
	    } else {
	        echo("Not a valid MD5 URL");
	        exit;
	    }
	}
	
	
	if (filter_var($F5_DownloadURL, FILTER_VALIDATE_URL)) {
	    echo("URL looks good \r\n");
	} else {
	    echo("Not a valid URL");
	    exit;
	}
	
	$FileName_Zip = substr($F5_DownloadURL, (strrpos($F5_DownloadURL, '/') + 1));
	
	
	$DownloadResults = DownloadFile($F5_DownloadURL, $FileName_Zip);
	if ($DownloadResults != true) {
	    echo "Download Error! ";	    
	}
    	
	if (isset($F5_DownloadURL_MD5) && ($F5_DownloadURL_MD5 != '')) {
	    $FileNameMD5_Zip = substr($F5_DownloadURL_MD5, (strrpos($F5_DownloadURL_MD5, '/') + 1));
	    
	    $DownloadResults = DownloadFile($F5_DownloadURL_MD5, $FileNameMD5_Zip);
	    if ($DownloadResults != true) {
	        echo "Download Error! ";
	    }
	    
    	$MD5_fileCheck =  md5_file($FileName_Zip);
    	$MD5_manifest  = trim(file_get_contents($FileNameMD5_Zip, NULL, NULL, 0, 33));
    	echo "MD5 from file: [$MD5_fileCheck], against checksum [$MD5_manifest] ...  ";
    	if ($MD5_fileCheck === $MD5_manifest) {
    	    echo "MD5 compare is correct! \r\n \r\n";
    	} else {
    	    echo "MD5 checksum invalid. FIle corrupted!!! \r\n \r\n";
    	}    	
	}
	
	//--------------------------------------------------------------------------------------------------------------------
	if (!file_exists($FileName_Zip)) {
	   echo "File does not exist. Please fix the path or manually put the file in this directory, and try again ";    
	   exit;
	}
	//-----------------------------------------------------------------------------------------------------------------
	$methods = array(
	    'kex' => 'diffie-hellman-group1-sha1',
	    'client_to_server' => array(
	        'crypt' => '3des-cbc',
	        'comp' => 'none'),
	    'server_to_client' => array(
	        'crypt' => 'aes256-cbc,aes192-cbc,aes128-cbc',
	        'comp' => 'none'));
	$callbacks = array('disconnect' => 'my_ssh_disconnect');
	if (!function_exists("ssh2_connect")) die("function ssh2_connect doesn't exist");
    //-------------------------------------------------------------------------------------------	
	echo "Starting GeoUpdater... \r\n \r\n";
	echo "Going to update the following Big IP's  \r\n ";
	var_dump($BigIPs_ip_array);
	echo "\r\n \r\n \r\n";
	
	$Updated_Server = 0;
	$Uploaded_File = 0;
	$TodaysDate = date("Y-m-d");
	$TmpDir = 'geoip-'.$TodaysDate.'/';
	$RemoteDir = '/shared/tmp/';	
	deleteDirectory($TmpDir);
	if (!mkdir($TmpDir, 0777, true)) {  die('Failed to create folders '.$TmpDir.' ...'); }
	
	echo "Unzipping file: $FileName_Zip ... "; 
	$zip = new ZipArchive;
	if ($zip->open($FileName_Zip) === TRUE) {
	    $zip->extractTo($TmpDir);
	    $zip->close();
	    unset($zip);
	    echo 'OK! \r\n \r\n';
	    $Files_arr = scandir($TmpDir, 1);
	    array_splice($Files_arr, count($Files_arr) - 3);
	    echo "Listing file names \r\n \r\n";
	    var_dump($Files_arr);
	} else {
	    echo 'Failed';
	    exit;
	}
	//--------------------------------------------------------------------------------------------------
	$numFiles = (count($Files_arr) - 1);
	$Num_BIGIPs = (count($BigIPs_ip_array) - 1);
	
	for ($x = 0; $x <= $Num_BIGIPs; $x++) {
	    $F5_Srv = $BigIPs_ip_array[$x]; // for HostName
	    $F5_Port = $BigIPs_port;
    	//------------------- Upload files to F5 ----------------------------------------
    	try {
    		echo "Connecting to server ".$BigIPs_fqdn_array[$x]." ($F5_Srv) - (Server ".($Updated_Server + 1)." of ".($Num_BIGIPs + 1).")... ";
    		$connection = ssh2_connect($F5_Srv, $F5_Port, $methods, $callbacks);
    		if (!$connection) die('Connection failed');
    		echo "Connected! \r\n ";
    		
    		if (ssh2_auth_password($connection, $BigIPs_username, $BigIPs_password)) {
    			echo "Authentication Successful! \r\n \r\n";
    		} else {
    			die('Authentication Failed...');
    		}
    		
    		echo "Sending files... \r\n \r\n";
    		for ($f = 0; $f <= $numFiles; $f++) {
    		    if (file_exists($TmpDir.$Files_arr[$f])) {
    		        echo "Uploading file (".$TmpDir.$Files_arr[$f].") ... ";
    		        ssh2_scp_send($connection, $TmpDir.$Files_arr[$f], $RemoteDir.$Files_arr[$f], 0644);
        			echo "Done!   \r\n \r\n";
        		} else {
        		    echo "The file ".$TmpDir.$Files_arr[$f]." does not exist";
        		}
    		}
    		unset($f);
    		echo "Disconnecting from server! \r\n";    		
    		ssh2_exec($connection, 'exit');
    		unset($connection); // disconnect from server
    		sleep(2);
    	} catch (Exception $e) {
    		$ErrorMsg = 'There was an error. Caught exception: '.$e->getMessage().', Line: '. __LINE__ .', File: '. __FILE__ .', Function: '. __FUNCTION__ .')';
    		echo $ErrorMsg;
    	}	
    	
    	echo "\r\n \r\n";
    	//--------------   SSH into F5 box and issue following command --------------------------
    	try {
        	echo "Connecting to ".$BigIPs_fqdn_array[$x]." to issue commands.. ";
        	if (!($connection1 = ssh2_connect($F5_Srv, $F5_Port))) {
        		echo "fail: unable to establish connection \r\n";
        		exit;
        	} else {
        		if (!ssh2_auth_password($connection1, $BigIPs_username, $BigIPs_password)) {
        			echo "fail: unable to authenticate \r\n";
        			exit;
        		} else {
        			if ($Debug == 1) { echo "okay: logged in.. \r\n"; }    			
        			//========================  create a shell ==========================================================
        			if (!($shell = ssh2_shell($connection1, 'vt102', null, 80, 40, SSH2_TERM_UNIT_CHARS))) {
        				echo "fail: unable to establish a shell\n";
        				exit;
        			} else {
        				if ($Debug == 1) { echo "Shell created... \r\n"; }
        				stream_set_blocking($shell, true);
        				//================================================================================================
        				// To install the file
        				for ($g = 0; $g <= (count($Files_arr) - 1); $g++) {
            				$Command = "geoip_update_data -f ".$RemoteDir.$Files_arr[$g];
            				if ($Debug == 1) { echo "Sending command: $Command \r\n\r\n"; }
            				fwrite($shell, $Command . PHP_EOL); // send a command
            				sleep(10);
                            echo "SENT! \r\n";
        				}
        				unset($g);
        				//================================================================================================
        				echo "exit \r\n ";
        				fwrite($shell, "exit\n"); // send a command
        				sleep(3);
        			}
        			fclose($shell);
        			unset($shell);
        		}
        		echo "Disconnecting from server! \r\n";
        		ssh2_exec($connection1, 'exit');
        		unset($connection1); // disconnect from server
        	}
    	} catch (Exception $e) {
    	    $ErrorMsg = 'There was an error. Caught exception: '.$e->getMessage().', Line: '. __LINE__ .', File: '. __FILE__ .', Function: '. __FUNCTION__ .')';
    	    echo $ErrorMsg;
    	}
    	$Updated_Server++;
	}
	echo "All done! \r\n \r\n";
	//----- general ------------
	function CLI_Help() {
	    echo "\r\n \r\nERROR: Arguements required! \r\n";
	    echo " Values: <HTTPS Download Path> <MD5 Download path - optional> \r\n";
	    
	    echo " go to Downloads.f5.com and browse to the file until you get the to 'DOWNLOAD LOCATIONS' page (with the different countries). Scroll down and right click on the button 'https' file download, and select 'Copy link address'. NOT ON A COUNTRY \r\n \r\n";
	    echo " eg: php geoip_updater.php https://downloads.f5.com/geoipfile_path.zip \r\n \r\n \r\n";
	    
	    exit;
	}
	
	function DownloadFile($URL, $FileName) {
	    try {
	        echo "download file....(this may take sometime)  ";
    	    $fp = fopen (dirname(__FILE__) . '/'.$FileName, 'w+');
    	    $ch = curl_init();
    	    curl_setopt($ch, CURLOPT_URL, $URL);
    	    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
    	    curl_setopt($ch, CURLOPT_TIMEOUT, 300);
    	    curl_setopt($ch, CURLOPT_FILE, $fp);  // write curl response to file
    	    curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
    	    
    	    $data = curl_exec ($ch);
    	    $error = curl_error($ch);
    	    curl_close ($ch);
    	    
    	    echo " Done! \r\n";
    	    return true;
	    } catch (Exception $e) {
	        $ErrorMsg = 'There was an error. Caught exception: '.$e->getMessage().', Line: '. __LINE__ .', File: '. __FILE__ .', Function: '. __FUNCTION__ .')';
	        echo $ErrorMsg;
	        return false;
	    }
	}
	
	function deleteDirectory($dir) {
	    system('rm -rf ' . escapeshellarg($dir), $retval);
	    return $retval == 0; // UNIX commands return zero on success
	}
	
	function convert($size) {
	    $unit=array('b','kb','mb','gb','tb','pb');
	    return @round($size/pow(1024,($i=floor(log($size,1024)))),2).' '.$unit[$i];
	}
	
	function my_ssh_disconnect($reason, $message, $language) {
	    printf("Server disconnected with reason code [%d] and message: %s\n", $reason, $message);
	}
?>
