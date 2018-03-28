#!/bin/sh
# Christopher Gray
# Version 2.3.0
#  3-28-18

if [ -z "$1" ]
   then
      echo "No server ip specified. Defaulting to localhost \r\n"
      server_ip=127.0.0.1
else
      server_ip=$1
      echo "ES Server is set to $server_ip \r\n"
fi

if [ -z "$2" ]
   then
      echo "No port specified. Defaulting to 9200 \r\n"
      server_port=9200
   else
      server_port=$2
      echo "port = $server_port \r\n"
fi

if [ -s "es_mapping_bigip.json" ]
then
   echo "Deleting old mappings...  "
   rm es_mapping_bigip.json
   rm es_mapping_http.json
   rm es_mapping_ddos.json
   rm es_mapping_dns.json
fi

echo "Downloading ES Mappings..."
wget -O "es_mapping_bigip.sh" "https://raw.githubusercontent.com/c2theg/Vendor_code/master/F5/syslog-ng/es_mapping_bigip.sh"
wget -O "es_mapping_http.sh" "https://raw.githubusercontent.com/c2theg/Vendor_code/master/F5/syslog-ng/es_mapping_http.sh"
wget -O "es_mapping_ddos.sh" "https://raw.githubusercontent.com/c2theg/Vendor_code/master/F5/syslog-ng/es_mapping_ddos.sh"
wget -O "es_mapping_dns.sh" "https://raw.githubusercontent.com/c2theg/Vendor_code/master/F5/syslog-ng/es_mapping_dns.sh"
wait
sudo chmod u+x es_mapping_bigip.sh
sudo chmod u+x es_mapping_http.sh
sudo chmod u+x es_mapping_ddos.sh
sudo chmod u+x es_mapping_dns.sh

# ---- Create the template for indexing the device logs
echo "\r\n \r\n "
echo "Deleting existing ES indexs if present....  \r\n \r\n "
echo "\r\n BigIP ... \r\n "
curl -XDELETE "$server_ip:$server_port/bigip*?pretty"
echo "\r\n HTTP ... \r\n "
curl -XDELETE "$server_ip:$server_port/http*?pretty"
echo "\r\n DDoS ... \r\n "
curl -XDELETE "$server_ip:$server_port/ddos*?pretty"
echo "\r\n DNS ... \r\n "
curl -XDELETE "$server_ip:$server_port/dns*?pretty"
wait
f
echo "\r\n TEMPLATES ... \r\n "

echo "\r\n BigIP ... \r\n "
curl -XDELETE "$server_ip:$server_port/_template/bigip*?pretty"
echo "\r\n HTTP ... \r\n "
wait
curl -XDELETE "$server_ip:$server_port/_template/http*?pretty"
echo "\r\n DDoS ... \r\n "
wait
curl -XDELETE "$server_ip:$server_port/_template/ddos*?pretty"
wait
echo "\r\n DNS ... \r\n "
curl -XDELETE "$server_ip:$server_port/_template/dns*?pretty"
wait

echo "\r\n \r\n "

echo "\r\n \r\n Creating DNS Logs ES 6 Mapping....  \r\n \r\n "
#curl -H 'Content-Type: application/json' -s -XPOST $server_ip:9200/_bulk --data-binary @es_mapping_dns.json
sudo ./es_mapping_dns.sh $server_ip $server_port

echo "\r\n \r\n Creating DDoS Logs ES 6 Mapping....  \r\n \r\n "
#curl -H 'Content-Type: application/json' -s -XPOST $server_ip:9200/_bulk --data-binary @es_mapping_ddos.json
sudo ./es_mapping_ddos.sh $server_ip $server_port

echo "\r\n \r\n Creating HTTP Logs ES 6 Mapping....  \r\n \r\n "
#curl -H 'Content-Type: application/json' -s -XPOST $server_ip:9200/_bulk --data-binary @es_mapping_http.json
sudo ./es_mapping_http.sh $server_ip $server_port

echo "Creating BigIP Logs ES 6 Mapping....  \r\n \r\n "
#curl -H 'Content-Type: application/json' -X PUT localhost:9200/_template/bigip.logs -d ''
#curl -H 'Content-Type: application/json' -s -XPOST $server_ip:9200/_bulk --data-binary @es_mapping_bigip.json
#curl -H 'Content-Type: application/json' -XPUT 'http://localhost:9200/bigip.logs*/positions/_mapping' -d @es_mapping_bigip.json
#curl -H 'Content-Type: application/json' -XPUT 'http://localhost:9200/_template/bigip.logs*' -d @es_mapping_bigip.json
#-- load text into variable, then push it via curl to es.
#JSON_Data='cat es_mapping_bigip.json'
#echo "$JSON_Data"
#curl -H 'Content-Type: application/json' -X PUT $server_ip:9200/_template/bigip.logs -d '$JSON_Data'
sudo ./es_mapping_bigip.sh $server_ip $server_port

#---------------------------------------------------
wait
echo "DONE! \r\n \r\n"

echo "\r\n \r\n Get ES Stats: $server_ip:$server_port \r\n \r\n "
curl -XGET "$server_ip:$server_port/_cat/indices?v&pretty"
curl -XGET "$server_ip:$server_port/_cat/health?v&pretty"
curl -XGET "$server_ip:$server_port/_cat/nodes?v&pretty"

echo "\r\n \r\n  Cluster Templates' \r\n \r\n"
curl -XGET "$server_ip:$server_port/_template/*?pretty"

echo "\r\n \r\n \r\n"
