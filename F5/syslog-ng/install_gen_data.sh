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
Last Updated:  4/10/2018
\r\n \r\n
Updating system first..."
sudo -E apt-get update
wait
sudo -E apt-get upgrade -y
wait
echo "Downloading required dependencies...\r\n\r\n"
#--------------------------------------------------------------------------------------------
#-- Install DNS-Perf --
# https://www.nominum.com/measurement-tools/

apt-get install libbind-dev libkrb5-dev libssl-dev libcap-dev libxml2-dev 
apt-get install bind9utils make

wget ftp://ftp.nominum.com/pub/nominum/dnsperf/2.1.0.0/dnsperf-src-2.1.0.0-1.tar.gz

tar xfvz dnsperf-src-2.1.0.0-1.tar.gz
cd dnsperf-src-2.1.0.0-1
./configure
make
sudo make install

dnsperf -h

#--- download latest Queryfile from Nominum ---
wget ftp://ftp.nominum.com/pub/nominum/dnsperf/data/queryfile-example-current.gz
gunzip queryfile-example-current.gz

#-------------------- HPING ---------------------
apt-get install -y nload traceroute hping3 tcl8.6
wait

### Examples ###
# https://pentest.blog/how-to-perform-ddos-test-as-a-pentester/

echo "  \r\n \r\n \r\n
 hping3 -V -c 1000000 -d 120 -S -w 64 -p 443 -s 443 --flood --rand-source 10.1.1.1    \r\n
 hping3 -2 -c 1000000 -s 5151 -p 80  --rand-source 10.1.1.1                   \r\n
 hping3 -S -P -U --flood -V --rand-source 10.1.1.1                              \r\n
 hping3 -c 20000 -d 120 -S -w 64 -p 443 --flood --rand-source 10.1.1.1           \r\n
 hping3 --icmp --spoof 10.1.1.1 BROADCAST_IP     \r\n
"
