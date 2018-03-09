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
Version:  0.5.1                             \r\n
Last Updated:  3/9/2018
\r\n \r\n
This is meant for Ubuntu 16.04.  \r\n \r\n"

#---------------------------------------------------------------------------------------------------------

if [ -s "create_es6_mappings.sh" ]
then
	echo "Deleting old configs...  "
	rm create_es6_mappings.sh
	rm kibana_indexs.sh
	rm f5_logstash_config.conf
	rm /etc/logstash/conf.d/f5_config.conf
	rm syslogng_bigip.conf
	rm /etc/syslog-ng/conf.d/bigip.conf
fi

echo "Downloading ES 6 Mappings Config"
wget -O "create_es6_mappings.sh" "https://raw.githubusercontent.com/c2theg/Vendor_code/master/F5/syslog-ng/create_es6_mappings.sh"
sudo chmod u+x create_es6_mappings.sh
sudo ./create_es6_mappings.sh
wait



echo "\r\n \r\n Downloading Logstash Config"
wget -O "f5_logstash_config.conf" "https://raw.githubusercontent.com/c2theg/Vendor_code/master/F5/syslog-ng/logstash.conf"
sudo cp "f5_logstash_config.conf" "/etc/logstash/conf.d/f5_config.conf"
wait



echo "\r\n \r\n Downloading Syslog_ng Config"
wget -O "syslogng_bigip.conf" "https://raw.githubusercontent.com/c2theg/Vendor_code/master/F5/syslog-ng/syslogng_bigip.conf"
sudo cp "syslogng_bigip.conf" "/etc/syslog-ng/conf.d/bigip.conf"
wait



echo "\r\n \r\n Downloading Test ES shell script.. "
wget -O "test_es.sh" "https://raw.githubusercontent.com/c2theg/srvBuilds/master/test_es.sh"
sudo chmod u+x test_es.sh
wait



echo "\r\n \r\n Downloading Sample Data.. "
wget -O "load_sample_data.sh" "https://raw.githubusercontent.com/c2theg/Vendor_code/master/F5/syslog-ng/load_sample_data.sh"
sudo chmod u+x load_sample_data.sh
sudo ./load_sample_data.sh
wait


echo "\r\n \r\n Visit -  http://127.0.0.1:5601    and  http://127.0.0.1:9200   \r\n \r\n"
echo "DONE! \r\n "
