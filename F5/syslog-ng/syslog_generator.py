#!/usr/bin/env python2
# -*- coding: utf-8 -*-
# Copyright (c) 2018 - Christopher Gray
# --- Version 0.0.10 - 3/25/18
import logging, sys
import logging.handlers
my_logger = logging.getLogger('MyLogger')
my_logger.setLevel(logging.INFO)

if len(sys.argv) < 4:
    print "Invalid usage. How to: python syslog_generator.py 192.168.1.2 514 syslog_lines.txt \r\n \r\n"
else:
    #syslog_server = '192.168.1.210'
    #syslog_port = 1514
    #fs_syslog_lines_to_send = 'syslog_lines.txt'
    syslog_server = sys.argv[1].strip()
    syslog_port = sys.argv[2].strip()
    fs_syslog_lines_to_send = sys.argv[3].strip()

    print "\r\n \r\n About to send text in (", fs_syslog_lines_to_send, ") to syslog srv at: ", syslog_server, ":", syslog_port, "... \r\n \r\n"
    handler = logging.handlers.SysLogHandler(address = (syslog_server,syslog_port))
    my_logger.addHandler(handler)

    #A list of messages to send
    with open(fs_syslog_lines_to_send) as f:
        fs_lines = f.readlines()
        if str(fs_lines) != '':
            print "\r\n Sending: |", fs_lines, "| \r\n"
            my_logger.info(fs_lines)


print "\r\n Done! \r\n "
