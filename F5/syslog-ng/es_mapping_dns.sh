#!/bin/sh
# Christopher Gray
# Version 0.1.3
#  3-28-18

#ElasticSearch Mapping for: F5 DNS
#https://support.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/bigip-external-monitoring-implementations-13-0-0/15.html#guid-87e43db0-6700-48d1-8e1b-d52e8bb6c899

if [ "$#" -eq  "0" ]
   then
      echo "No server ip specified. Defaulting to localhost \r\n"
      server_ip=127.0.0.1
else
      server_ip=$1
      echo "ES Server is set to $server_ip \r\n"
fi

curl -H 'Content-Type: application/json' -X PUT $server_ip:9200/_template/dns.logs -d '
{
   "index_patterns" : "dns.logs*",
    "settings" : {
      "number_of_shards": 3,
      "number_of_replicas" : 0,
      "refresh_interval": "1s",
      "index.routing.allocation.include.size": "small",
      "index.routing.allocation.include.rack": "r1"
    },
   "mappings": {
      "properties": {
         "@timestamp": {
            "type": "date",
            "format": "strict_date_optional_time||epoch_millis"
         },
         "@version": {
            "type": "string"
         },
         "host": {
            "type": "string"
         },
         "message": {
            "type": "string"
         },
         "path": {
            "type": "string"
         },
         "syslog_hostname": {
            "type": "string",
              "analyzer": "english",
              "fields": {
                  "raw": {
                      "type":  "string",
                      "index": "not_analyzed"
                  }
              }
         },
         "Subscriber": {
            "type": "ip"
         },
        "port": {
            "type": "integer"
         },
         "Query": {
            "type": "string",
              "analyzer": "english",
              "fields": {
                  "raw": {
                      "type":  "string",
                      "index": "not_analyzed"
                  }
              }
         },
        "QueryType": {
            "type": "string",
              "analyzer": "english",
              "fields": {
                  "raw": {
                      "type":  "string",
                      "index": "not_analyzed"
                  }
              }
         },
         "DNS_response": {
            "type": "string",
              "analyzer": "english",
              "fields": {
                  "raw": {
                      "type":  "string",
                      "index": "not_analyzed"
                  }
              }
         },
         "timestamp": {
            "type": "string"
         }
      }





   }
}'
