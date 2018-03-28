#!/bin/sh
# Christopher Gray
# Version 0.1.4
#  3-28-18

#ElasticSearch Mapping for: F5 DDoS
#https://support.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/bigip-external-monitoring-implementations-13-0-0/15.html#guid-87e43db0-6700-48d1-8e1b-d52e8bb6c899

if [ "$#" -eq  "0" ]
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
      #echo "port = $server_port \r\n"
fi

curl -H 'Content-Type: application/json' -X PUT $server_ip:$server_port/_template/ddos.logs -d '
{
   "index_patterns":"ddos.logs*",
   "settings":{  
      "number_of_shards":3,
      "number_of_replicas" : 0,
      "refresh_interval": "1s",
      "index.routing.allocation.include.size": "small",
      "index.routing.allocation.include.rack": "r1"
   },
   "mappings":{
      "logs": {
         "_source": {
            "enabled": false
         },
         "_meta": {
           "version": "1.0"
         },
         "dynamic": false,
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
            "hostname":{  
               "type":"text",
               "analyzer":"english",
               "fields":{  
                  "raw":{  
                     "type":"text",
                     "index":"false"
                  }
               }
            },
            "bigip_mgmt_ip":{  
               "type":"ip"
            },
            "date_time":{  
               "type":"date"
            },
            "dest_ip":{  
               "type":"ip"
            },
            "dest_port":{  
               "type":"integer"
            },
            "device_product":{  
               "type":"text",
               "analyzer":"english",
               "fields":{  
                  "raw":{  
                     "type":"text",
                     "index":"false"
                  }
               }
            }, 
            "device_vendor":{  
               "type":"text",
               "analyzer":"english",
               "fields":{  
                  "raw":{  
                     "type":"text",
                     "index":"false"
                  }
               }
            }, 
            "device_version":{  
               "type":"text",
               "analyzer":"english",
               "fields":{  
                  "raw":{  
                     "type":"text",
                     "index":"false"
                  }
               }
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
            "errdefs_msgno":{  
               "type":"integer"
            },
            "errdefs_msg_name":{  
               "type":"text",
               "analyzer":"english",
               "fields":{  
                  "raw":{  
                     "type":"text",
                     "index":"false"
                  }
               }
            },         
            "severity":{  
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
            "route_domain":{  
               "type":"integer"
            },
            "src_ip":{  
               "type":"ip"
            },
            "src_port":{  
               "type":"integer"
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
