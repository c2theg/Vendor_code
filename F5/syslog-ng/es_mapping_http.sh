#!/bin/sh
# Christopher Gray
# Version 0.1.4
#  3-28-18

#ElasticSearch Mapping for: F5 HTTP / ASM
#https://support.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/bigip-external-monitoring-implementations-13-0-0/15.html#guid-87e43db0-6700-48d1-8e1b-d52e8bb6c899

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
      #echo "port = $server_port \r\n"
fi

curl -H 'Content-Type: application/json' -X PUT $server_ip:$server_port/_template/http.logs -d '
{
      "index_patterns":"http.logs*",
      "settings":{  
            "number_of_shards": 3,
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
