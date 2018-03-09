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
Version:  0.1                             \r\n
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
	rm syslogng_bigip.conf
fi

echo "Downloading ES 6 Mappings Config"
wget -O "create_es6_mappings.sh" "https://raw.githubusercontent.com/c2theg/Vendor_code/master/F5/syslog-ng/create_es6_mappings.sh"
sudo chmod u+x create_es6_mappings.sh
sudo ./create_es6_mappings.sh
wait



echo "Downloading Kibana Config"
wget -O "kibana_indexs.sh" "https://raw.githubusercontent.com/c2theg/Vendor_code/master/F5/syslog-ng/kibana_indexs.sh"
sudo chmod u+x kibana_indexs.sh
sudo ./kibana_indexs.sh
wait



echo "Downloading Logstash Config"
wget -O "f5_logstash_config.conf" "https://raw.githubusercontent.com/c2theg/Vendor_code/master/F5/syslog-ng/logstash.conf"
sudo cp "f5_logstash_config.conf" "/etc/logstash/conf.d/f5_config.conf"
wait



echo "Downloading BTSync Config"
wget -O "syslogng_bigip.conf" "https://raw.githubusercontent.com/c2theg/Vendor_code/master/F5/syslog-ng/syslogng_bigip.conf"
sudo cp "syslogng_bigip.conf" "/etc/syslog-ng/conf.d/bigip.conf"
wait


