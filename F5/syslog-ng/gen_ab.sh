
#!/bin/sh
# Christopher Gray
# Version 0.2.2
#  11-7-18

if [ -z "$1" ]
then
      echo "No dest defined to attack! please define one before continuing \r\n"
      exit
else
      server_ip=$1
      echo "Server is set to $server_ip \r\n"
fi


#---- apache bench attack ----
echo "Starting a Apache bench strest test... \r\n"

ab -t 60 -n 10000000 http://$server_ip
cat load_urls.txt | parallel "ab -n 10000 -c 10 {}"

#while true
#do
    #ab -r -c 1000 -n 1000000 $server_ip  &>/dev/null &
#    ab -n 1000 -c 10 -k -H "Accept-Encoding: gzip, deflate" $server_ip
#done
