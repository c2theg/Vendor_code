#!/bin/sh
#    If you update this from Windows, using Notepad ++, do the following:
#       sudo apt-get -y install dos2unix
#       dos2unix <FILE>
#       chmod u+x <FILE>
#
clear
echo "
    Updated Attack scripts


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
Version:  0.0.10                             \r\n
Last Updated:  6/19/2019
\r\n \r\n
This is meant for Ubuntu 16.04+  \r\n \r\n"
#---------------------------------------------------
if [ -f update_attacks.sh ]; then
    rm update_attacks.sh gen_data.sh gen_udp_floods.sh gen_legit_dns_traffic.sh attack_dns_nxdomain.py attack_dns_watertorture_wget.sh attack_phantomdomain.py kill_all_attacks.sh
fi

echo "\r\n \r\n Downloading scripts... \r\n"
#--- files ----
wget https://raw.githubusercontent.com/c2theg/Vendor_code/master/F5/syslog-ng/update_attacks.sh
wget https://raw.githubusercontent.com/c2theg/Vendor_code/master/F5/syslog-ng/gen_data.sh
wget https://raw.githubusercontent.com/c2theg/Vendor_code/master/F5/syslog-ng/gen_udp_floods.sh
wget https://raw.githubusercontent.com/c2theg/Vendor_code/master/F5/syslog-ng/gen_legit_dns_traffic.sh
wget https://raw.githubusercontent.com/c2theg/Vendor_code/master/F5/syslog-ng/attack_dns_nxdomain.py
wget https://raw.githubusercontent.com/c2theg/Vendor_code/master/F5/syslog-ng/attack_dns_watertorture_wget.sh
wget https://raw.githubusercontent.com/c2theg/Vendor_code/master/F5/syslog-ng/attack_phantomdomain.py
wget https://raw.githubusercontent.com/c2theg/Vendor_code/master/F5/syslog-ng/kill_all_attacks.sh
wget https://raw.githubusercontent.com/c2theg/Vendor_code/master/F5/syslog-ng/set_geohash.py

#---- Permissions ---
chmod u+x update_attacks.sh gen_data.sh gen_udp_floods.sh gen_legit_dns_traffic.sh attack_dns_nxdomain.py attack_dns_watertorture_wget.sh attack_phantomdomain.py kill_all_attacks.sh set_geohash.py

#---- add auto update to crontab ----
Cron_output=$(crontab -l | grep "update_attacks.sh")
if [ -z "$Cron_output" ]
then
    echo "Script not in crontab. Adding."
    line="10 3 * * * /home/ubuntu/update_attacks.sh >> /var/log/update_attacks.log 2>&1"
    (crontab -u root -l; echo "$line" ) | crontab -u root -

#   line="@reboot /root/update_attacks.sh >> /var/log/update_attacks.log 2>&1"
#   (crontab -u root -l; echo "$line" ) | crontab -u root -
else
      echo "Script was found in crontab. skipping addition"
fi

echo "\r\n \r\n DONE! \r\n \r\n "
