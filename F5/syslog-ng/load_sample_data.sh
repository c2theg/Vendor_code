#
#
#
# --- Device logs
#
#
#

echo "Loading sample data > bigip.logs... \r\n "
curl -H 'Content-Type: application/json' -X POST 'http://localhost:9200/bigip.logs-2010.03.31.13/logs' -d '{"message":"Mar 31 17:58:52 192.168.1.63 debug gtmd[7937]: 011ae039:7: Check probing of IP:Port 10.128.20.15:80 in DC /Common/DC2","@version":"1","@timestamp":"2010-03-31T13:58:52.000Z","path":"/var/log/bigip/device/192.168.1.63- -2010-03-31.log","host":"ubuntu","syslog_timestamp":"Mar 31 17:58:52","syslog_hostname":"192.168.1.63","syslog_severity":"debug","syslog_program":"gtmd[7937]","syslog_messag e":"011ae039:7: Check probing of IP:Port 10.128.20.15:80 in DC /Common/DC2"}'


#
#
#
# --- HTTP logs
#
#
#
echo "Loading sample data > http.logs... \r\n "
curl -H 'Content-Type: application/json' -X POST  'http://localhost:9200/http.logs-2010.03.20.13/logs' -d '{"message":"Mar 20 12:34:26 192.168.1.50 10.128.10.1 54105 10.128.10.51 443 1.1 10.128.20.17 80 200 18 600 /login.php \"Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.87 Safari/537.36\" \"\" \r","@version":"1","@timestamp":"2010-03-20T08:34:26.000Z","path":"/var/log/bigip/http/192.168.1.50--2010-03- 20.log","host":"ubuntu","syslog_timestamp":"Mar 20 12:34:26","syslog_hostname":"192.168.1.50","client_ip":"10.128.10.1","client_port":"54105","vitual_ip":"10.128.10.51"," virtual_port":"443","http_version":"1.1","server_ip":"10.128.20.17","server_port":"80","http_status":"200","response_ti me":"18","bytes_received":"600","uri_path":"/login.php","agent":"\"Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.87 Safari/537.36\"","referrer":"\"\""}'


#
#
#
# --- DDoS Logs
#
#
#
echo "Loading sample data > ddos.logs... \r\n "
curl -H 'Content-Type: application/json' -X POST 'http://localhost:9200/ddos.logs-2010.03.20.13/logs' -d '{"message":"Mar 20 11:24:31 192.168.1.50 action=\"Drop\",hostname=\"bigip1.kostas.gr\",bigip_mgmt_ip=\"192.168.1.248\",context_name=\"/Common/vs_DDoS\ ",date_time=\"Mar 20 2016 11:24:31\",dest_ip=\"10.128.10.203\",dest_port=\"80\",device_product=\"Advanced Firewall Module\",device_vendor=\"F5\",device_version=\"12.0.0.1.0.628\",dos_attack_event=\"Attack Sampled\",dos_attack_id=\"4130097038\",dos_attack_name=\"TCP SYN flood\",dos_packets_dropped=\"229\",dos_packets_received=\"231\",errdefs_msgno=\"23003138\",errdefs_msg_name= \"Network DoS Event\",flow_id=\"0000000000000000\",severity=\"4\",partition_name=\"Common\",route_domain=\"0\",source_ip=\"1 97.81.185.12\",source_port=\"6839\",vlan=\"/Common/Internal\"","@version":"1","@timestamp":"2010-03- 20T07:24:31.000Z","path":"/var/log/bigip/ddos/192.168.1.50--2016-03- 20.log","host":"ubuntu","syslog_timestamp":"Mar 20 11:24:31","syslog_hostname":"192.168.1.50","action":"Drop","f5_hostname":"bigip1.kostas.gr","mgmt_ip":"192.168.1.2 48","context":"/Common/vs_DDoS","attack_time":"Mar 20 2016 11:24:31","dest_ip":"10.128.10.203","dest_port":"80","dos_attack_event":"Attack Sampled","dos_attack_id":"4130097038","dos_attack_name":"TCP SYN flood","packets_dropped":"229","packets_received":"231","severity":"4","partition_name":"Common","route_domain":"0 ","source_ip":"197.81.185.12","source_port":"6839","vlan":"/Common/Internal"}'


echo "Done loading sample data! \r\n \r\n"
