import logging
import logging.handlers
my_logger = logging.getLogger('MyLogger')
my_logger.setLevel(logging.INFO)

#Define SyslogHandler
syslog_server = '192.168.1.210'
syslog_port = 1514

print "About to send Syslog message to: "+syslog_server+":"+syslog_port+"... \r\n \r\n"
handler = logging.handlers.SysLogHandler(address = (syslog_server,syslog_port))
my_logger.addHandler(handler)

#A list of messages to send
List1 = [
  'test1',
  'test2',
  'test3'
]

for row in List1:
  print "Sending ["+ List1[0] + "]... \r\n"
  my_logger.info(List1[0])

print "Done! \r\n "
