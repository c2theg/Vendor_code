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
Version:  0.6.5                             \r\n
Last Updated:  3/24/2018
\r\n \r\n
This is meant for Ubuntu 16.04+  \r\n \r\n"

#---------------------------------------------------------------------------------------------------------

if [ -s "create_es6_mappings.sh" ]
then
	echo "Deleting old configs...  "
	rm create_es6_mappings.sh
	rm load_sample_data.sh
	rm test_es.sh
	rm logstash/f5_logging.conf
	rm /etc/logstash/conf.d/f5_logging.conf
	#rm syslogng_bigip.conf
	#rm /etc/syslog-ng/conf.d/bigip.conf
	rm /etc/logstash/patterns/f5_grok_pattern.yml
	rm update_geoipdb.sh
	rm elasticsearch-f5.yml
	rm f5_syslogpri.yml
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

#------ Move configs -----------
if [ ! -d "/etc/logstash/patterns/" ]
then
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

sudo chmod -R 755 /var/lib/logstash
sudo chown -R logstash:logstash /var/lib/logstash

sudo mv "f5_logging.conf"  "logstash/f5_logging.conf"
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


echo "\r\n \r\n Downloading Update_GeoIP shell script.. "
wget -O "update_geoipdb.sh" "https://raw.githubusercontent.com/c2theg/Vendor_code/master/F5/syslog-ng/update_geoipdb.sh"
sudo chmod u+x update_geoipdb.sh
wait


echo "\r\n \r\n Downloading Sample Data.. "
wget -O "load_sample_data.sh" "https://raw.githubusercontent.com/c2theg/Vendor_code/master/F5/syslog-ng/load_sample_data.sh"
sudo chmod u+x load_sample_data.sh
#sudo ./load_sample_data.sh
wait

echo "\r\n \r\n To update your logstash plugins: \r\n \r\n
	gem install atomic -v '1.1.100'    \r\n 
	/usr/share/logstash/bin/logstash-plugin update \r\n \r\n"



echo "DONE! \r\n "
