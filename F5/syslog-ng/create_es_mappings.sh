#
#
#
# ---- Create the template for indexing the device logs
#
#
#
#

echo "\r\n \r\n "

echo "Creating BigIP Logs ES Mapping....  \r\n \r\n "


curl -XPUT localhost:9200/_template/bigip.logs -d '
{
"template" : "bigip.logs*", "settings" : {
"number_of_shards" : 4 },
"mappings": { "logs": {
"properties": { "@timestamp": {
"type": "date",
"format": "strict_date_optional_time||epoch_millis" },
"@version": { "type": "string"
}, "host": {
"type": "string" },
"message": { "type": "string"
}, "path": {
"type": "string" },
"syslog_hostname": {
"type": "string", "analyzer": "english", "fields": {
"raw": {
"type": "string", "index": "not_analyzed"
} }
}, "syslog_message": {
"type": "string", "analyzer": "english", "fields": {
"raw": {
"type": "string", "index": "not_analyzed"
} }
}, "syslog_program": {
"type": "string", "analyzer": "english", "fields": {
"raw": {
"type": "string",
"index": "not_analyzed" }
} },
"syslog_severity": { "type": "string",
"analyzer": "english", "fields": {
"raw": {
"type": "string", "index": "not_analyzed"
} }
}, "syslog_timestamp": {
"type": "string" }
} }
} }'


#
#
#
# ---  Create the template for indexing the HTTP logs
#
#
#
echo "\r\n \r\n Creating HTTP Logs ES Mapping....  \r\n \r\n "

curl -XPUT localhost:9200/_template/http.logs -d ' {
"template" : "http.logs*", "settings" : {
"number_of_shards" : 4 },
"mappings": {
"logs": { "properties": {
"@timestamp": { "type": "date",
"format": "strict_date_optional_time||epoch_millis" },
"@version": { "type": "string"
}, "agent": {
"type": "string", "analyzer": "english", "fields": {
"raw": {
"type": "string", "index": "not_analyzed"
} }
}, "bytes_received": {
"type": "integer" },
"client_ip": {
"type": "ip" },
"client_port": { "type": "string"
}, "host": {
"type": "string" },
"http_status": {
"type": "string" },
"http_version": { "type": "string"
}, "message": {
"type": "string" },
"path": {
"type": "string" },
"referrer": { "type": "string",
"analyzer": "english", "fields": {
"raw": {
"type": "string", "index": "not_analyzed"
} }
}, "response_time": {
"type": "integer" },
"server_ip": { "type": "ip"
}, "server_port": {
"type": "string" },
"syslog_hostname": {
"type": "string", "analyzer": "english", "fields": {
"raw": {
"type": "string",
"index": "not_analyzed" }
} },
"syslog_timestamp": { "type": "string"
}, "uri_path": {
"type": "string", "analyzer": "english", "fields": {
"raw": {
"type": "string",
"index": "not_analyzed" }
} },
"virtual_port": {
"type": "string" },
"vitual_ip": { "type": "ip"
} }
} }
}'


#
#
#
#----  Create the template for indexing the DDoS logs
#
#
#
#
echo "\r\n \r\n Creating DDoS Logs ES Mapping....  \r\n \r\n "

curl -XPUT localhost:9200/_template/ddos.logs -d ' {
"template" : "ddos.logs*", "settings" : {
"number_of_shards" : 4 },
"mappings": { "logs": {
"properties": { "@timestamp": {
"type": "date",
"format": "strict_date_optional_time||epoch_millis" },
"@version": { "type": "string"
}, "action": {
"type": "string", "analyzer": "english", "fields": {
"raw": {
"type": "string", "index": "not_analyzed"
} }
}, "attack_time": {
"type": "string" },
"dest_ip": { "type": "ip"
}, "dest_port": {
"type": "string" },
"dos_attack_event": { "type": "string",
"analyzer": "english", "fields": {
"raw": {
"type": "string",
"index": "not_analyzed" }
} },
"dos_attack_id": { "type": "string",
"analyzer": "english", "fields": {
"raw": {
"type": "string", "index": "not_analyzed"
} }
}, "dos_attack_name": {
"type": "string", "analyzer": "english", "fields": {
"raw": {
"type": "string", "index": "not_analyzed"
} }
}, "f5_hostname": {
"type": "string", "analyzer": "english", "fields": {
"raw": {
"type": "string", "index": "not_analyzed"
} }
}, "host": {
"type": "string" },
"message": { "type": "string"
}, "mgmt_ip": {
"type": "ip" },
"context": { "type": "string",
"analyzer": "english",
"fields": { "raw": {
"type": "string",
"index": "not_analyzed" }
} },
"packets_dropped": { "type": "integer"
}, "packets_received": {
"type": "integer" },
"partition_name": { "type": "string",
"analyzer": "english", "fields": {
"raw": {
"type": "string", "index": "not_analyzed"
} }
}, "path": {
"type": "string" },
"route_domain": {
"type": "integer" },
"severity": { "type": "integer"
}, "source_ip": {
"type": "ip" },
"source_port": {
"type": "string" },
"syslog_hostname": { "type": "string",
"analyzer": "english", "fields": {
"raw": {
"type": "string", "index": "not_analyzed"
} }
}, "syslog_timestamp": {
"type": "string" },
"vlan": {
"type": "string",
"analyzer": "english", "fields": {
"raw": {
"type": "string", "index": "not_analyzed"
} }
} }
} }
}'

echo "\r\n \r\n DONE!  \r\n \r\n "
