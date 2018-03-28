#!/bin/sh
# Christopher Gray
# Version 0.0.2
#  3-27-18
curl -H 'Content-Type: application/json' -X PUT localhost:9200/_template/bigip.logs -d '
{  
   "index_patterns":"bigip.logs*",
   "settings":{
      "number_of_shards":3,
      "number_of_replicas" : 0,
      "refresh_interval": "10s",
      "index.routing.allocation.include.size": "small",
      "index.routing.allocation.include.rack": "r1",
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
