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
Version:  0.0.4                             \r\n
Last Updated:  5/1/2018
\r\n \r\n
This is meant for Ubuntu 16.04+  \r\n \r\n"

#---------------------------------------------------------------------------------------------------------
if [ -s "logstash_palo.conf" ]
then
	echo "Deleting old configs...  "
	rm palo_es6-template.json
fi

echo "Downloading ES 6 Mappings Config"
wget -O "palo_es6-template.json" "https://raw.githubusercontent.com/c2theg/Vendor_code/master/palo_alto/palo_es6-template.json"
wait
#---------------------------------------------------------------------
echo "\r\n \r\n Downloading Logstash Config"
wget -O "logstash_palo.conf" "https://raw.githubusercontent.com/c2theg/Vendor_code/master/palo_alto/logstash_palo.conf"
wget -O "custom_grok_patterns.yml" "https://raw.githubusercontent.com/c2theg/srvBuilds/master/ES/custom_grok_patterns.yml"

wget -O "logrotate_syslog_PA_net.conf" "https://raw.githubusercontent.com/c2theg/Vendor_code/master/palo_alto/logrotate_syslog_net.conf"
wget -O "logrotate_syslog_PA_url.conf" "https://raw.githubusercontent.com/c2theg/Vendor_code/master/palo_alto/logrotate_syslog_url.conf"

echo "\r\n \r\n"
echo "moving configs....  "
#------ Move configs -----------
if [ ! -d "/etc/logstash/patterns/" ]
then
	echo "Creating directories... "
	mkdir "/etc/logstash/patterns/"
fi
sudo mv "custom_grok_patterns.yml" "/etc/logstash/patterns/custom_grok_patterns.yml"

if [ ! -d "logstash" ]
then
	mkdir logstash
fi
sudo mv "logstash_palo.conf"  "logstash/logstash_palo.conf"
sudo chmod -R 755 /var/lib/logstash
sudo chown -R logstash:logstash /var/lib/logstash

#-------------------------------------------------------
#echo "\r\n \r\n Downloading Syslog_ng Config"
#sudo chown -R syslog:adm /var/log/bigip
wget -O "syslog-ng_palo.conf" "https://raw.githubusercontent.com/c2theg/Vendor_code/master/palo_alto/syslog-ng_palo.conf"
sudo cp "syslog-ng_palo.conf" "/etc/syslog-ng/conf.d/syslog-ng_palo.conf"
#sudo -u /etc/init.d/syslog-ng restart
sudo service syslog-ng restart
#wait
#-------------------------------------------------------

#---- Logrotate ----
sudo mv "logrotate_syslog_PA_net.conf" "/etc/logrotate.d/logrotate_syslog_PA_net.conf"
sudo mv "logrotate_syslog_PA_url.conf" "/etc/logrotate.d/logrotate_syslog_PA_url.conf"

#----------- Update ES config --------------------------------------------
mv /etc/elasticsearch/elasticsearch.yml  /etc/elasticsearch/elasticsearch6_backup.yml
wait
wget  -O "elasticsearch-palo.yml" "https://raw.githubusercontent.com/c2theg/Vendor_code/master/palo_alto/elasticsearch-palo.yml"
wait
cp elasticsearch-palo.yml /etc/elasticsearch/elasticsearch.yml
wait
echo " Restarting ElasticSearch... \r\n \r\n "
sudo /etc/init.d/elasticsearch restart
#-------------------------------------------------------

echo "\r\n \r\n Downloading Test ES shell script.. "
wget -O "test_es.sh" "https://raw.githubusercontent.com/c2theg/srvBuilds/master/test_es.sh"
sudo chmod u+x test_es.sh
wait

echo "\r\n \r\n Downloading Update ELK plugins shell script.. "
wget -O "update_elk_plugins.sh" "https://raw.githubusercontent.com/c2theg/srvBuilds/master/update_elk_plugins.sh"
sudo chmod u+x update_elk_plugins.sh
wait
#-------------------------------------------------------
echo "\r\n \r\n Logstash plugins: \r\n \r\n"
/usr/share/logstash/bin/logstash-plugin list --verbose

echo "\r\n \r\n To update your logstash plugins: \r\n \r\n
	sudo ./update_elk_plugins.sh    \r\n"

sudo ./update_elk_plugins.sh

if [ -s "logstash/logstash_palo.conf" ] 
then
	#echo "\r\n \r\n  Starting Logstash (this may take 1 minute)... \r\n \r\n"
	#sudo -u logstash /usr/share/logstash/bin/logstash --path.settings=/etc/logstash -f logstash/f5_logging.conf
	#sudo /usr/share/logstash/bin/logstash --path.settings=/etc/logstash -f /home/ubuntu/logstash/f5_logging.conf
	
	echo "To start logstash use the following: \r\n \r\n
	   sudo  /usr/share/logstash/bin/logstash --path.settings=/etc/logstash -f /home/ubuntu/logstash/logstash_palo.conf 
	\r\n \r\n"
	wait
fi
#-------------------------------------------------------
echo "DONE! \r\n "
