#!/bin/sh
#    If you update this from Windows, using Notepad ++, do the following:
#       sudo apt-get -y install dos2unix
#       dos2unix <FILE>
#       chmod u+x <FILE>
#
clear
echo "
 _____             _         _    _          _                                   
|     |___ ___ ___| |_ ___ _| |  | |_ _ _   |_|                                  
|   --|  _| -_| .'|  _| -_| . |  | . | | |   _                                   
|_____|_| |___|__,|_| |___|___|  |___|_  |  |_|                                  
                                     |___|                                       
                                                                                 
 _____ _       _     _           _              _____    __    _____             
|     | |_ ___|_|___| |_ ___ ___| |_ ___ ___   |     |__|  |  |   __|___ ___ _ _ 
|   --|   |  _| |_ -|  _| . | . |   | -_|  _|  | | | |  |  |  |  |  |  _| .'| | |
|_____|_|_|_| |_|___|_| |___|  _|_|_|___|_|    |_|_|_|_____|  |_____|_| |__,|_  |
                            |_|                                             |___|
\r\n \r\n
Version:  0.6.10                             \r\n
Last Updated:  4/19/2018
\r\n \r\n
This is meant for Ubuntu 16.04+  \r\n \r\n"

#---------------------------------------------------------------------------------------------------------

if [ -s "create_es6_mappings.sh" ]
then
	echo "Deleting old configs...  "
	rm create_es6_mappings.sh
	rm load_sample_data.sh
	rm test_es.sh
	rm gen_data.sh
	rm logstash/f5_logging.conf
	rm /etc/logstash/conf.d/f5_logging.conf
	#rm syslogng_bigip.conf
	#rm /etc/syslog-ng/conf.d/bigip.conf
	rm update_geoipdb.sh
	rm elasticsearch-f5.yml
	rm cleanup_installs.sh
	rm /etc/logstash/patterns/f5_grok_pattern.yml
	rm /etc/logstash/dictionaries/f5_syslogpri.yml
	rm update_attacks.sh
fi

echo "Downloading ES 6 Mappings Config"
#wget -O "create_es6_mappings.sh" "https://raw.githubusercontent.com/c2theg/Vendor_code/master/F5/syslog-ng/create_es6_mappings.sh"
wget -O "create_es6_mappings.sh" "https://raw.githubusercontent.com/c2theg/Vendor_code/master/F5/syslog-ng/create_es6_mappings_template.sh"
sudo chmod u+x create_es6_mappings.sh
sudo ./create_es6_mappings.sh
wait

#---------------------------------------------------------------------
echo "\r\n \r\n Downloading Logstash Config"
wget -O "f5_logging.conf" "https://raw.githubusercontent.com/c2theg/Vendor_code/master/F5/syslog-ng/logstash2.conf"
wget -O "f5_syslogpri.yml" "https://raw.githubusercontent.com/c2theg/Vendor_code/master/F5/syslog-ng/f5_syslogpri.yml"
wget -O "f5_grok_pattern.yml" "https://raw.githubusercontent.com/c2theg/Vendor_code/master/F5/syslog-ng/f5_grok_pattern.yml"

echo "\r\n \r\n"
echo "moving configs....  "
#------ Move configs -----------
if [ ! -d "/etc/logstash/patterns/" ]
then
	echo "Creating directories... "
	mkdir "/etc/logstash/patterns/"
fi
sudo mv "f5_grok_pattern.yml" "/etc/logstash/patterns/f5_grok_pattern.yml"

if [ ! -d "/etc/logstash/dictionaries/" ]
then
	mkdir "/etc/logstash/dictionaries/"
fi
sudo mv "f5_syslogpri.yml" "/etc/logstash/dictionaries/f5_syslogpri.yml"

if [ ! -d "logstash" ]
then
	mkdir logstash
fi
sudo mv "f5_logging.conf"  "logstash/f5_logging.conf"


sudo chmod -R 755 /var/lib/logstash
sudo chown -R logstash:logstash /var/lib/logstash
echo "Done! \r\n "
#---------------------------------------------------------------------

bin/logstash-plugin list --verbose

if [ -s "logstash/f5_logging.conf" ] 
then
	#echo "\r\n \r\n  Starting Logstash (this may take 1 minute)... \r\n \r\n"
	#sudo -u logstash /usr/share/logstash/bin/logstash --path.settings=/etc/logstash -f logstash/f5_logging.conf
	#sudo /usr/share/logstash/bin/logstash --path.settings=/etc/logstash -f /home/ubuntu/logstash/f5_logging.conf
	
	echo "To start logstash use the following: \r\n \r\n
	   sudo  /usr/share/logstash/bin/logstash --path.settings=/etc/logstash -f /home/ubuntu/logstash/f5_logging.conf 
	   
	\r\n \r\n"
	wait
fi

#-------------------------------------------------------
#echo "\r\n \r\n Downloading Syslog_ng Config"
#mkdir /var/log/bigip
#mkdir /var/log/bigip/device
#mkdir /var/log/bigip/ddos
#sudo chmod -R 755 /var/log/bigip
#sudo chown -R syslog:adm /var/log/bigip
#wget -O "syslogng_bigip.conf" "https://raw.githubusercontent.com/c2theg/Vendor_code/master/F5/syslog-ng/syslogng_bigip.conf"
#sudo cp "syslogng_bigip.conf" "/etc/syslog-ng/conf.d/bigip.conf"
#sudo -u /etc/init.d/syslog-ng restart
#wait
#-------------------------------------------------------

#----------- Update ES config --------------------------------------------
mv /etc/elasticsearch/elasticsearch.yml  /etc/elasticsearch/elasticsearch6_backup.yml
wait
wget  -O "elasticsearch-f5.yml" "https://raw.githubusercontent.com/c2theg/Vendor_code/master/F5/syslog-ng/elasticsearch.yml"
wait
cp elasticsearch-f5.yml /etc/elasticsearch/elasticsearch.yml
wait
echo " Restarting ElasticSearch... \r\n \r\n "
sudo /etc/init.d/elasticsearch restart
#-------------------------------------------------------


echo "\r\n \r\n Downloading Test ES shell script.. "
wget -O "test_es.sh" "https://raw.githubusercontent.com/c2theg/srvBuilds/master/test_es.sh"
sudo chmod u+x test_es.sh
wait


echo "\r\n \r\n Downloading Update ELK plugins shell script.. "
wget -O "update_elk_plugins.sh" "https://raw.githubusercontent.com/c2theg/Vendor_code/master/F5/syslog-ng/update_elk_plugins.sh"
sudo chmod u+x update_elk_plugins.sh
wait


echo "\r\n \r\n Downloading install_gen_data script.. "
wget -O "install_gen_data.sh" "https://raw.githubusercontent.com/c2theg/Vendor_code/master/F5/syslog-ng/install_gen_data.sh"
sudo chmod u+x install_gen_data.sh
wait

echo "\r\n \r\n Downloading Sample Data Generator.. "
wget -O "gen_data.sh" "https://raw.githubusercontent.com/c2theg/Vendor_code/master/F5/syslog-ng/gen_data.sh"
sudo chmod u+x gen_data.sh
wait

echo "\r\n \r\n Downloading Cleanup script. "
wget -O "cleanup_installs.sh" "https://raw.githubusercontent.com/c2theg/Vendor_code/master/F5/syslog-ng/cleanup_installs.sh"
sudo chmod u+x cleanup_installs.sh
wait

echo "\r\n \r\n Downloading Attack Script Updater "
wget -O "update_attacks.sh" "https://raw.githubusercontent.com/c2theg/Vendor_code/master/F5/syslog-ng/update_attacks.sh"
sudo chmod u+x update_attacks.sh
wait


echo "\r\n \r\n To update your logstash plugins: \r\n \r\n
	sudo ./update_elk_plugins.sh    \r\n"

sudo ./update_elk_plugins.sh


echo "DONE! \r\n "
