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





