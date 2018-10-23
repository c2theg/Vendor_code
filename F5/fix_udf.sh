#!/bin/sh
export TERM=xterm
export EDITOR=nano

# By: Christopher Gray
# 10/23/18
# version: 0.0.2
#------ Auto add to startup ------------------------------------
Cron_output=$(crontab -l | grep "fix_udf.sh")
#echo "The output is: [ $Cron_output ]"
if [ -z "$Cron_output" ]
then
    echo "Script not in crontab. Adding."
 
    line="@reboot /root/fix_udf.sh"
    (crontab -u root -l; echo "$line" ) | crontab -u root -
    
    wait
    /etc/init.d/cron restart  > /dev/null
else
    echo "Script was found in crontab. skipping addition"
fi
