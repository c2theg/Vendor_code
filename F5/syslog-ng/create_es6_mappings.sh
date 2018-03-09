# Christopher Gray
# Version 2.0
# . 3-9-18
#
# ---- Create the template for indexing the device logs
#
#
#
#

echo "\r\n \r\n "

echo "Creating BigIP Logs ES 6 Mapping....  \r\n \r\n "

curl -H 'Content-Type: application/json' -X PUT localhost:9200/_template/bigip.logs -d '
{  
   "template":"bigip.logs*",
   "settings":{
      "number_of_shards":4,

       "analysis": {
         "analyzer": {
           "my_analyzer": {
             "tokenizer": "my_tokenizer"
           }
         },
         "tokenizer": {
           "my_tokenizer": {
             "type": "path_hierarchy",
             "delimiter": "-",
             "replacement": "/",
             "skip": 2
           }
         }
      }
   },
   "mappings":{
      "logs":{  
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
# ---  Create the template for indexing the HTTP logs
#
#
#
echo "\r\n \r\n Creating HTTP Logs ES Mapping....  \r\n \r\n "

curl -H 'Content-Type: application/json' -X PUT localhost:9200/_template/http.logs -d '
{  
   "template":"http.logs*",
   "settings":{  
      "number_of_shards":4
   },
   "mappings":{  
      "logs":{  
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


