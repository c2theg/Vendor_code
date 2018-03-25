''' - Version 0.0.5  - 3/24/18 '''
import logging
import logging.handlers
my_logger = logging.getLogger('MyLogger')
my_logger.setLevel(logging.INFO)

#Define SyslogHandler
syslog_server = '192.168.1.210'
syslog_port = 1514

print "\r\n \r\n About to send Syslog message to: ", syslog_server, ":", syslog_port, "... \r\n \r\n"
handler = logging.handlers.SysLogHandler(address = (syslog_server,syslog_port))
my_logger.addHandler(handler)

#A list of messages to send
List1 = [
  "<134>1 2018-03-22T08:01:19.969759-07:00 bigip1.dnstest.lab tmm 16694 23003139 [F5@12276 action=\"Drop\" attack_type=\"MX\" hostname=\"bigip1.dnstest.lab\" bigip_mgmt_ip=\"192.168.1.100\" context_name=\"/Common/dns_udp_listener\" date_time=\"Mar 22 2018 08:01:19\" dest_ip=\"162.159.25.175\" dest_port=\"53\" device_product=\"Advanced Firewall Module\" device_vendor=\"F5\" device_version=\"13.1.0.1.0.0.8\" dns_query_name=\"mountaineerpublishing.com\" dns_query_type=\"MX\" errdefs_msgno=\"23003139\" errdefs_msg_name=\"DNS Event\" flow_id=\"0005565750f68689\" severity=\"5\" partition_name=\"Common\" route_domain=\"0\" source_ip=\"10.10.0.50\" source_port=\"48560\" vlan=\"/Common/inside\"] \"Mar 22 2018 08:01:19\",\"192.168.1.100\",\"bigip1.dnstest.lab\",\"/Common/dns_udp_listener\",\"/Common/inside\",\"MX\",\"mountaineerpublishing.com\",\"MX\",\"Drop\",\"10.10.0.50\",\"162.159.25.175\",\"48560\",\"53\",\"0\",\"0005565750f68689\"",
  'test2',
  'test3'
]

for (var i = 0; i < List1.length; i++) {
  print "Sending [", List1[i], "]... \r\n"
  my_logger.info(List1[i])

print "\r\n Done! \r\n "
