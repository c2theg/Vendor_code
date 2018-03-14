#!/bin/sh
#
# Christopher Gray
# Version 2.1.7
# . 3-14-18
#
# ---- Create the mapping for indexing the device logs
#
#
#
echo "\r\n \r\n "
echo "Deleting existing ES indexs if present....  \r\n \r\n "
echo "\r\n bigip.logs ... \r\n "
curl -XDELETE 'localhost:9200/bigip*?pretty'
echo "\r\n http.logs ... \r\n "
curl -XDELETE 'localhost:9200/http*?pretty'
echo "\r\n ddos.logs ... \r\n "
curl -XDELETE 'localhost:9200/ddos*?pretty'
wait

echo "\r\n \r\n "
echo "Creating BigIP Logs ES 6 Mapping....  \r\n \r\n "

curl -H 'Content-Type: application/json' -X PUT localhost:9200/bigip -d '{
   "mappings":{
      "logs":{
         "_all": { 
            "enabled": false
         },
         "properties":{  
            "@timestamp":{  
               "type":"date",
               "format":"strict_date_optional_time||epoch_millis"
            },
            "@version":{  
               "type":"text"
            },
            "host":{  
               "type":"text"
            },
            "message":{
               "analyzer" : "standard",
               "type":"text"
            },
            "path":{
               "type":"text"
            },
            "syslog_hostname":{  
               "type":"text",
               "analyzer":"english",
               "fields":{  
                  "raw":{  
                     "type":"text",
                     "index":"false"
                  }
               }
            },
            "syslog_message":{  
               "type":"text",
               "analyzer":"english",
               "fields":{  
                  "raw":{  
                     "type":"text",
                     "index":"false"
                  }
               }
            },
            "syslog_program":{  
               "type":"text",
               "analyzer":"english",
               "fields":{  
                  "raw":{  
                     "type":"text",
                     "index":"false"
                  }
               }
            },
            "syslog_severity":{  
               "type":"text",
               "analyzer":"english",
               "fields":{  
                  "raw":{  
                     "type":"text",
                     "index":"false"
                  }
               }
            },
            "syslog_timestamp":{  
               "type":"text"
            }
         }
      }
   }
}'



#
#
#
# ---  Create the mapping for indexing the HTTP logs
#
#
#
echo "\r\n \r\n Creating HTTP Logs ES 6 Mapping....  \r\n \r\n "

curl -H 'Content-Type: application/json' -X PUT localhost:9200/http -d '{
   "mappings":{  
      "logs":{
         "_all": { 
            "enabled": false
         },
         "properties":{  
            "@timestamp":{  
               "type":"date",
               "format":"strict_date_optional_time||epoch_millis"
            },
            "@version":{  
               "type":"text"
            },
            "agent":{  
               "type":"text",
               "analyzer":"english",
               "fields":{  
                  "raw":{  
                     "type":"text",
                     "index":"false"
                  }
               }
            },
            "bytes_received":{  
               "type":"integer"
            },
            "client_ip":{  
               "type":"ip"
            },
            "client_port":{  
               "type":"text"
            },
            "host":{  
               "type":"text"
            },
            "http_status":{  
               "type":"text"
            },
            "http_version":{  
               "type":"text"
            },
            "message":{  
               "type":"text"
            },
            "path":{  
               "type":"text"
            },
            "referrer":{  
               "type":"text",
               "analyzer":"english",
               "fields":{  
                  "raw":{  
                     "type":"text",
                     "index":"false"
                  }
               }
            },
            "response_time":{  
               "type":"integer"
            },
            "server_ip":{  
               "type":"ip"
            },
            "server_port":{  
               "type":"text"
            },
            "syslog_hostname":{  
               "type":"text",
               "analyzer":"english",
               "fields":{  
                  "raw":{  
                     "type":"text",
                     "index":"false"
                  }
               }
            },
            "syslog_timestamp":{  
               "type":"text"
            },
            "uri_path":{  
               "type":"text",
               "analyzer":"english",
               "fields":{  
                  "raw":{  
                     "type":"text",
                     "index":"false"
                  }
               }
            },
            "virtual_port":{  
               "type":"text"
            },
            "vitual_ip":{  
               "type":"ip"
            }
         }
      }
   }
}'


#
#
#
#----  Create the mapping for indexing the DDoS logs
#
#
#
#
echo "\r\n \r\n Creating DDoS Logs ES 6 Mapping....  \r\n \r\n "

curl -H 'Content-Type: application/json' -X PUT localhost:9200/ddos -d '{
   "mappings":{  
      "logs":{
         "_all": { 
            "enabled": false
         },
         "properties":{  
            "@timestamp":{  
               "type":"date",
               "format":"strict_date_optional_time||epoch_millis"
            },
            "@version":{  
               "type":"text"
            },
            "action":{  
               "type":"text",
               "analyzer":"english",
               "fields":{  
                  "raw":{  
                     "type":"text",
                     "index":"false"
                  }
               }
            },
            "attack_time":{  
               "type":"text"
            },
            "dest_ip":{  
               "type":"ip"
            },
            "dest_port":{  
               "type":"text"
            },
            "dos_attack_event":{  
               "type":"text",
               "analyzer":"english",
               "fields":{  
                  "raw":{  
                     "type":"text",
                     "index":"false"
                  }
               }
            },
            "dos_attack_id":{  
               "type":"text",
               "analyzer":"english",
               "fields":{  
                  "raw":{  
                     "type":"text",
                     "index":"false"
                  }
               }
            },
            "dos_attack_name":{  
               "type":"text",
               "analyzer":"english",
               "fields":{  
                  "raw":{  
                     "type":"text",
                     "index":"false"
                  }
               }
            },
            "f5_hostname":{  
               "type":"text",
               "analyzer":"english",
               "fields":{  
                  "raw":{  
                     "type":"text",
                     "index":"false"
                  }
               }
            },
            "host":{  
               "type":"text"
            },
            "message":{  
               "type":"text"
            },
            "mgmt_ip":{  
               "type":"ip"
            },
            "context":{  
               "type":"text",
               "analyzer":"english",
               "fields":{  
                  "raw":{  
                     "type":"text",
                     "index":"false"
                  }
               }
            },
            "packets_dropped":{  
               "type":"integer"
            },
            "packets_received":{  
               "type":"integer"
            },
            "partition_name":{  
               "type":"text",
               "analyzer":"english",
               "fields":{  
                  "raw":{  
                     "type":"text",
                     "index":"false"
                  }
               }
            },
            "path":{  
               "type":"text"
            },
            "route_domain":{  
               "type":"integer"
            },
            "severity":{  
               "type":"integer"
            },
            "source_ip":{  
               "type":"ip"
            },
            "source_port":{  
               "type":"text"
            },
            "syslog_hostname":{  
               "type":"text",
               "analyzer":"english",
               "fields":{  
                  "raw":{  
                     "type":"text",
                     "index":"false"
                  }
               }
            },
            "syslog_timestamp":{  
               "type":"text"
            },
            "vlan":{  
               "type":"text",
               "analyzer":"english",
               "fields":{  
                  "raw":{  
                     "type":"text",
                     "index":"false"
                  }
               }
            }
         }
      }
   }
}'

echo "DONE! \r\n \r\n"

curl -XGET 'localhost:9200/_cat/indices?v&pretty'
curl -XGET 'localhost:9200/_cat/health?v&pretty'
curl -XGET 'localhost:9200/_cat/nodes?v&pretty'

echo "\r\n \r\n \r\n"
