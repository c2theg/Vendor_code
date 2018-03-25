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
  'test1',
  'test2',
  'test3'
]

for (var i = 0; i < List1.length; i++) {
  print "Sending [", List1[i], "]... \r\n"
  my_logger.info(List1[i])

print "\r\n Done! \r\n "
