<?php
/*
 ------ STEPS -----
 By: Christopher Gray - christophermjgray@gmail.com - 9/16/17 - Version 0.0.8
	https://devcentral.f5.com/codeshare/auto-updates-geoip-database-on-big-ip-1061
	https://github.com/c2theg/Vendor_code/edit/master/F5/geoip_updater.php

  you need PHP to get this to work.
 - For Ubuntu:

 sudo apt-get -y install php-cli php-curl php-mcrypt php-ssh2 php-zip

 then on the CLI:
 F5S=f5-a.example.com,f5-b.example.com php geoip_updater.php <downloads.f5.com https geoip file url - on location page> <optional, md5 file url>

 */

	error_reporting(E_ALL);
	ini_set("display_errors",1);
	ini_set('error_reporting', E_ALL);
	date_default_timezone_set('UTC');
	set_time_limit(3600);
	ini_set("memory_limit","1024M");
	ini_set("precision", "16");
	$Debug = 1;

	//---
	$BigIPs_array = explode(',', getenv('F5S'));
	$Num_BIGIPs = (count($BigIPs_array));
	if ($Num_BIGIPs < 1) { CLI_Help(); }

	$BigIPs_username = "root";
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

	//---
	echo "Starting GeoUpdater..." . PHP_EOL;
	echo "Going to update the following Big IP's" . PHP_EOL;
	echo join(', ', $BigIPs_array) . PHP_EOL;

	if (filter_var($F5_DownloadURL, FILTER_VALIDATE_URL)) {
		echo("URL looks good" . PHP_EOL);
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
			echo "MD5 compare is correct." . PHP_EOL;
		} else {
			echo "MD5 checksum invalid. FIle corrupted!" . PHP_EOL;
		}
	}

	//---
	if (!file_exists($FileName_Zip)) {
		echo "File does not exist. Please fix the path or manually put the file in this directory, and try again ";
		exit;
	}
	//---
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

	$Updated_Server = 0;
	$Uploaded_File = 0;
	$TodaysDate = date("Y-m-d");
	$TmpDir = 'geoip-'.$TodaysDate;
	$RemoteDir = '/shared/tmp/';
	recursiveRemoveDirectory($TmpDir);
	if (!mkdir($TmpDir, 0777, true)) { die('Failed to create folders '.$TmpDir.' ...'); }

	echo "Unzipping file: $FileName_Zip to $TmpDir ... ";
	$zip = new ZipArchive;
	if ($zip->open($FileName_Zip) === TRUE) {
		$zip->extractTo($TmpDir.'/');
		$zip->close();
		unset($zip);
		echo "OK." . PHP_EOL;
		$Files_arr = scandir($TmpDir.'/', 1);
		array_splice($Files_arr, count($Files_arr) - 3);
		echo "Listing file names" . PHP_EOL;
		var_dump($Files_arr);
	} else {
		echo 'Failed';
		exit;
	}
	//---
	$numFiles = (count($Files_arr) - 1);

	for ($x = 0; $x < $Num_BIGIPs; $x++) {
		$F5_Srv = $BigIPs_array[$x]; // for HostName
		$F5_Port = $BigIPs_port;
		try {
			echo "Connecting to server $F5_Srv - (Server ".($Updated_Server + 1)." of ".($Num_BIGIPs).")... ";
			$connection = ssh2_connect($F5_Srv, $F5_Port, $methods, $callbacks);
			if (!$connection) die('Connection failed');
			echo "Connected." . PHP_EOL;

			if (ssh2_auth_agent($connection, $BigIPs_username)) {
				echo "Authentication Successful." . PHP_EOL;
			} else {
				die('Authentication Failed...');
			}

			//--- Upload files to F5 ---
			echo "Sending files..." . PHP_EOL;
			for ($f = 0; $f <= $numFiles; $f++) {
				if (file_exists($TmpDir.'/'.$Files_arr[$f])) {
				echo "Uploading file (".$TmpDir.'/'.$Files_arr[$f].") to ".$RemoteDir.$Files_arr[$f]." ... ";
				ssh2_scp_send($connection, $TmpDir.'/'.$Files_arr[$f], $RemoteDir.$Files_arr[$f], 0644);
					echo "Done." . PHP_EOL;
				} else {
					echo "The file ".$TmpDir.'/'.$Files_arr[$f]." does not exist" . PHP_EOL;
				}
			}
			unset($f);

			//--- SSH into F5 and issue commands ---
			if ($Debug == 1) { echo "Sending commands..." . PHP_EOL; }
			//=== create a shell ===
			if (!($shell = ssh2_shell($connection, 'vt102', null, 80, 40, SSH2_TERM_UNIT_CHARS))) {
				echo "fail: unable to establish a shell" . PHP_EOL;
				exit;
			} else {
				if ($Debug == 1) { echo "Shell created..." . PHP_EOL; }
				stream_set_blocking($shell, true);
				//====
				// To install the file
				for ($g = 0; $g <= (count($Files_arr) - 1); $g++) {
					$Command = "geoip_update_data -f ".$RemoteDir.$Files_arr[$g];
					if ($Debug == 1) { echo "Sending command: $Command ... "; }
					fwrite($shell, "$Command\n"); // send a command
					sleep(10);
					echo "Done." . PHP_EOL;
				}
				unset($g);
			}
			fclose($shell);
			unset($shell);

			echo "Disconnecting from server $F5_Srv ... ";
			ssh2_exec($connection, 'exit');
			unset($connection); // disconnect from server
			sleep(2);
		} catch (Exception $e) {
			$ErrorMsg = 'There was an error. Caught exception: '.$e->getMessage().', Line: '. __LINE__ .', File: '. __FILE__ .', Function: '. __FUNCTION__ .')';
			echo $ErrorMsg;
		}
		echo "Done." . PHP_EOL;

		$Updated_Server++;
	}
	echo "All done." . PHP_EOL;

	//--- general ---
	function CLI_Help() {
		echo "ERROR: Arguments required:" . PHP_EOL;
		echo "Usage: F5S=a.example.com,b.example.com php geoip_updater.php <HTTPS Download Path> <MD5 Download path - optional>" . PHP_EOL;
		echo "go to Downloads.f5.com and browse to the file until you get the to 'DOWNLOAD LOCATIONS' page (with the different countries)." . PHP_EOL;
		echo "Scroll down and right click on the button 'https' file download, and select 'Copy link address'. NOT ON A COUNTRY" . PHP_EOL;
		echo "eg: php geoip_updater.php https://downloads.f5.com/geoipfile_path.zip" . PHP_EOL;
		exit;
	}

	function DownloadFile($URL, $FileName) {
		try {
			echo "download file....(this may take some time)" . PHP_EOL;
			echo "$URL -> $FileName" . PHP_EOL;
			$fp = fopen (dirname(__FILE__) . '/'.$FileName, 'w+');
			$ch = curl_init();
			curl_setopt($ch, CURLOPT_URL, $URL);
			curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
			curl_setopt($ch, CURLOPT_TIMEOUT, 300);
			curl_setopt($ch, CURLOPT_FILE, $fp); // write curl response to file
			curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);

			$data = curl_exec ($ch);
			$error = curl_error($ch);
			curl_close ($ch);

			echo "Done." . PHP_EOL;
			return true;
		} catch (Exception $e) {
			$ErrorMsg = 'There was an error. Caught exception: '.$e->getMessage().', Line: '. __LINE__ .', File: '. __FILE__ .', Function: '. __FUNCTION__ .')';
			echo $ErrorMsg;
			return false;
		}
	}

	function recursiveRemoveDirectory($directory) {
		if (file_exists($directory) && is_dir($directory)) {
			foreach (glob("{$directory}/*") as $file) {
				if (is_dir($file)) {
					recursiveRemoveDirectory($file);
				} else {
					unlink($file);
				}
			}
			rmdir($directory);
		}
	}

	function convert($size) {
		$unit=array('b','kb','mb','gb','tb','pb');
		return @round($size/pow(1024,($i=floor(log($size,1024)))),2).' '.$unit[$i];
	}

	function my_ssh_disconnect($reason, $message, $language) {
		echo "Server disconnected with reason code [$reason] and message: $message" . PHP_EOL;
	}
