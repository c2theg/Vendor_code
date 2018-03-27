#!/bin/sh
# Christopher Gray
# Version 2.2.1
#  3-27-18
#

if [ -s "es_mapping_bigip.json" ]
then
   echo "Deleting old mappings...  "
   rm es_mapping_bigip.json
   rm es_mapping_http.json
   rm es_mapping_ddos.json
   rm es_mapping_dns.json
fi

echo "Downloading ES Mappings..."
wget -O "es_mapping_bigip.json" "https://raw.githubusercontent.com/c2theg/Vendor_code/master/F5/syslog-ng/es_mapping_bigip.json"
wget -O "es_mapping_http.json" "https://raw.githubusercontent.com/c2theg/Vendor_code/master/F5/syslog-ng/es_mapping_http.json"
wget -O "es_mapping_ddos.json" "https://raw.githubusercontent.com/c2theg/Vendor_code/master/F5/syslog-ng/es_mapping_ddos.json"
wget -O "es_mapping_dns.json" "https://raw.githubusercontent.com/c2theg/Vendor_code/master/F5/syslog-ng/es_mapping_dns.json"
wait

# ---- Create the template for indexing the device logs
echo "\r\n \r\n "
echo "Deleting existing ES indexs if present....  \r\n \r\n "
echo "\r\n BigIP ... \r\n "
curl -XDELETE 'localhost:9200/bigip*?pretty'
echo "\r\n HTTP ... \r\n "
curl -XDELETE 'localhost:9200/http*?pretty'
echo "\r\n DDoS ... \r\n "
curl -XDELETE 'localhost:9200/ddos*?pretty'
echo "\r\n DNS ... \r\n "
curl -XDELETE 'localhost:9200/dns*?pretty'
wait

echo "\r\n TEMPLATES ... \r\n "

echo "\r\n BigIP ... \r\n "
curl -XDELETE 'localhost:9200/_template/bigip*?pretty'
echo "\r\n HTTP ... \r\n "
wait
curl -XDELETE 'localhost:9200/_template/http*?pretty'
echo "\r\n DDoS ... \r\n "
wait
curl -XDELETE 'localhost:9200/_template/ddos*?pretty'
wait
echo "\r\n DNS ... \r\n "
curl -XDELETE 'localhost:9200/_template/dns*?pretty'
wait

echo "\r\n \r\n "
#curl -H 'Content-Type: application/json' -X PUT localhost:9200/_template/bigip.logs -d ''
echo "Creating BigIP Logs ES 6 Mapping....  \r\n \r\n "
curl -s -XPOST localhost:9200/_bulk --data-binary @es_mapping_bigip.json

echo "\r\n \r\n Creating HTTP Logs ES 6 Mapping....  \r\n \r\n "
curl -s -XPOST localhost:9200/_bulk --data-binary @es_mapping_http.json

echo "\r\n \r\n Creating DDoS Logs ES 6 Mapping....  \r\n \r\n "
curl -s -XPOST localhost:9200/_bulk --data-binary @es_mapping_ddos.json

echo "\r\n \r\n Creating DDoS Logs ES 6 Mapping....  \r\n \r\n "
curl -s -XPOST localhost:9200/_bulk --data-binary @es_mapping_dns.json
echo "DONE! \r\n \r\n"


echo "\r\n \r\n Get ES Stats:  \r\n \r\n "
curl -XGET 'localhost:9200/_cat/indices?v&pretty'
curl -XGET 'localhost:9200/_cat/health?v&pretty'
curl -XGET 'localhost:9200/_cat/nodes?v&pretty'

echo "\r\n \r\n  Cluster Templates' \r\n \r\n"
curl -XGET 'localhost:9200/_template/*?pretty'

echo "\r\n \r\n \r\n"
