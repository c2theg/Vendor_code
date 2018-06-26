#!/usr/bin/env python
import threading
import socket
from scapy.all import *

srcIP = raw_input('Source IP (1.1.2.10): ')
dstIP = raw_input('Dest IP: ')
DNSQuery = raw_input('DNS Query (aaa.com): ')
QueryType = raw_input('Query Type (A, AAAA, MX, NX): ')

#send(IP(dst="10.59.141.30", src="1.2.3.4")/UDP(sport=RandShort())/DNS(rd=1,opcode=0,qd=DNSQR(qname="aaa.com",qclass="IN",qtype="A")),loop=1)

if srcIP is None:
	srcIP = '1.1.2.10'

if DNSQuery is None:
	DNSQuery = 'aaa.com'

if QueryType is None:
	QueryType = 'A'

send(IP(dst=dstIP, src=srcIP)/UDP(sport=RandShort())/DNS(rd=1,opcode=0,qd=DNSQR(qname=DNSQuery,qclass="IN",qtype=QueryType)),loop=1)
