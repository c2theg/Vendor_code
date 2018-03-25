# --- Version 0.0.8 - 3/24/18
import logging
import logging.handlers
my_logger = logging.getLogger('MyLogger')
my_logger.setLevel(logging.INFO)

#Define SyslogHandler
syslog_server = '192.168.1.210'
syslog_port = 1514
fs_syslog_lines_to_send = 'syslog_lines.txt'

print "\r\n \r\n About to send Syslog message to: ", syslog_server, ":", syslog_port, "... \r\n \r\n"
handler = logging.handlers.SysLogHandler(address = (syslog_server,syslog_port))
my_logger.addHandler(handler)

#A list of messages to send
with open(fs_syslog_lines_to_send) as f:
    fs_lines = f.readlines()
    if str(fs_lines) != '':
      print "Sending: [", fs_lines, "]... \r\n \r\n"
      my_logger.info(fs_lines)


print "\r\n Done! \r\n "
