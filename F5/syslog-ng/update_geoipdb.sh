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
Version:  0.0.1                             \r\n
Last Updated:  3/21/2018
\r\n \r\n
This is meant for Ubuntu 16.04+  \r\n \r\n"
#--------------------------------------------------------------------------------------

# example file: /etc/elasticsearch/ingest-geoip/GeoLite2-Country.mmdb.gz

#download files from: https://dev.maxmind.com/geoip/geoip2/geolite2/
#untar files 
# move files to: /etc/elasticsearch/ingest-geoip/

echo "Downloading latest file from Maxmind.com....  \r\n \r\n"
wget -O "GeoLite2-City.tar.gz" "http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.tar.gz"

echo "DONE! Untarring.. \r\n "
tar xvzf GeoLite2-City.tar.gz GeoLite2-City_20180306/GeoLite2-City.mmdb

echo "\r\n Moving files \r\n "
cp GeoLite2-City.mmdb /etc/elasticsearch/ingest-geoip/

echo "Done! \r\n \r\n"
