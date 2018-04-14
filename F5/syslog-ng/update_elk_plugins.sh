#!/bin/sh
#    If you update this from Windows, using Notepad ++, do the following:
#       sudo apt-get -y install dos2unix
#       dos2unix <FILE>
#       chmod u+x <FILE>
#
clear
echo "
    Updated ELK plugins


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
Version:  0.1.6                             \r\n
Last Updated:  4/14/2018
\r\n \r\n
This is meant for Ubuntu 16.04+  \r\n \r\n"


sudo /usr/share/logstash/bin/logstash-plugin update
#sudo /usr/share/logstash/bin/logstash-plugin update logstash-input-beats

#--------------------------------------------------------------------------------------
echo "Removing old GeoIP databases ... "
rm /etc/elasticsearch/ingest-geoip/GeoLite2-ASN.mmdb.gz
rm /etc/elasticsearch/ingest-geoip/GeoLite2-Country.mmdb.gz
rm /etc/elasticsearch/ingest-geoip/GeoLite2-City.mmdb.gz
echo "DONE! \r\n "

#--------------------- City ---------------------
echo "Downloading latest City database file from Maxmind.com....  \r\n \r\n"
wget -O "GeoLite2-City.tar.gz" "http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.tar.gz"
wait

echo "\r\n Removing files.. "
rm /etc/elasticsearch/ingest-geoip/README.txt
rm /etc/elasticsearch/ingest-geoip/LICENSE.txt
rm /etc/elasticsearch/ingest-geoip/COPYRIGHT.txt

echo "DONE! \r\n \r\n Uncompressing.. \r\n "
tar xvzf GeoLite2-City.tar.gz --strip-components=1 -C /etc/elasticsearch/ingest-geoip/
echo "Done! \r\n \r\n"
wait

#--------------------- Country ---------------------
echo "Downloading latest Country database file from Maxmind.com....  \r\n \r\n"
wget -O "GeoLite2-Country.tar.gz" "http://geolite.maxmind.com/download/geoip/database/GeoLite2-Country.tar.gz"
wait

echo "\r\n Removing files.. "
rm /etc/elasticsearch/ingest-geoip/README.txt
rm /etc/elasticsearch/ingest-geoip/LICENSE.txt
rm /etc/elasticsearch/ingest-geoip/COPYRIGHT.txt

echo "DONE! \r\n \r\n Uncompressing.. \r\n "
tar xvzf GeoLite2-Country.tar.gz --strip-components=1 -C /etc/elasticsearch/ingest-geoip/
echo "Done! \r\n \r\n"
wait

#--------------------- ASN ---------------------
echo "Downloading latest ASN database file from Maxmind.com....  \r\n \r\n"
wget -O "GeoLite2-ASN.tar.gz" "http://geolite.maxmind.com/download/geoip/database/GeoLite2-ASN.tar.gz"
wait

echo "\r\n Removing files.. "
rm /etc/elasticsearch/ingest-geoip/README.txt
rm /etc/elasticsearch/ingest-geoip/LICENSE.txt
rm /etc/elasticsearch/ingest-geoip/COPYRIGHT.txt

echo "DONE! \r\n \r\n Uncompressing.. \r\n "
tar xvzf GeoLite2-ASN.tar.gz --strip-components=1 -C /etc/elasticsearch/ingest-geoip/
echo "Done! \r\n \r\n"
wait

echo "All files are in: /etc/elasticsearch/ingest-geoip/  \r\n \r\n"
echo "Add to crontab (will update every Wednesday at 4:05am) \r\n \r\n
  5 4 * * 3 /home/ubuntu/update_elk_plugins.sh >> /var/log/update_elk_plugins.log 2>&1
\r\n \r\n"

#---------------------------------------------
echo "Update elasticsearch plugins... \r\n "
sudo /usr/share/elasticsearch/bin/elasticsearch-plugin list

echo "Done! \r\n \r\n"
