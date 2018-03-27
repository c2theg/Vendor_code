#!/bin/sh
# Christopher Gray
# Version 2.2.0
# . 3-27-18
#
# ---- Create the template for indexing the device logs
#
#
echo "\r\n \r\n "
echo "Deleting existing ES indexs if present....  \r\n \r\n "
echo "\r\n BigIP ... \r\n "
curl -XDELETE 'localhost:9200/bigip*?pretty'
echo "\r\n HTTP ... \r\n "
curl -XDELETE 'localhost:9200/asm*?pretty'
echo "\r\n DDoS ... \r\n "
curl -XDELETE 'localhost:9200/ddos*?pretty'
wait
echo "\r\n DNS ... \r\n "
curl -XDELETE 'localhost:9200/dns*?pretty'
wait

echo "\r\n TEMPLATES ... \r\n "

echo "\r\n BigIP ... \r\n "
curl -XDELETE 'localhost:9200/_template/bigip*?pretty'
echo "\r\n HTTP ... \r\n "
wait
curl -XDELETE 'localhost:9200/_template/asm*?pretty'
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
curl -XGET 'localhost:9200/_cat/indices?v&pretty'
curl -XGET 'localhost:9200/_cat/health?v&pretty'
curl -XGET 'localhost:9200/_cat/nodes?v&pretty'

echo "\r\n \r\n  Cluster Templates' \r\n \r\n"
curl -XGET 'localhost:9200/_template/*?pretty'

echo "\r\n \r\n \r\n"
