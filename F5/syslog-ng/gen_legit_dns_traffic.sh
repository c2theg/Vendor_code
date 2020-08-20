#!/bin/sh
# Christopher Gray
# Version 0.0.6
#  11-7-18

if [ -z "$1" ]
then
      echo "No dest defined to attack! please define one before continuing \r\n"
      exit
else
      server_ip=$1
      echo "Server is set to $server_ip \r\n"
fi


if [ -z "$2" ]
then
      echo "Defaulting queries to send is set to: 1500 \r\n"
      queries_ps=1500
else
      queries_ps=$2
      #echo "port = $server_port \r\n"
fi


if [ -f queryfile-example-current ]
then
      echo "Loading Nominum sample data file! \r\n \r\n"
else
      echo "Missing Nominum sample data... downloading it!  \r\n \r\n "
      wget -O "queryfile-example-current.gz" "ftp://ftp.nominum.com/pub/nominum/dnsperf/data/queryfile-example-current.gz"
      echo "Decompressing file... \r\n \r\n"
      gunzip queryfile-example-current.gz
      wait
fi

#-----------------------------------------------------------------------------------------------------------------

# https://github.com/cobblau/dnsperf
# Dnsperf supports the following command line options:

# -s     Specifies the DNS server's IP address. The default IP is 127.0.0.1.
# -p     Specifies the DNS server's port. The default Port is 53.
# -d     Specifies the input data file. Input data file contains query domain and query type.
# -t     Specifies the timeout for query completion in millisecond. The default timeout is 3000ms.
# -Q     Specifies the max number of queries to be send. The default number is 1000.
# -c     Specifies the number of concurrent queries. The default number is 100. Dnsperf will randomly pick a query domain from data file as QNAME.
# -l     Specifies how long to run tests in seconds. The default number is infinite.
# -e     This will sets the real client IP in query string following the rules defined in edns-client-subnet.

# -i     Specifies interval of queries in seconds. The default number is zero. This option is not supported currently.
# -P     Specifies the transport layer protocol to send DNS queries, udp or tcp. As we know, although UDP is the suggested protocol, DNS queries can be send either by UDP or TCP. The default is udp. tcp is not supported currently, and it is coming soon.
# -f     Specify address family of DNS transport, inet or inet6. The default is inet. inet6 is not supported currently.
# -v     Verbose: report the RCODE of each response on stdout.
# -h     Print the usage of dnsperf.

if [ -f queryfile-example-current ]
then
      #sudo dnsperf -s $server_ip -d queryfile-example-current -c 200 -T 10 -l 300 -q 10000 -Q 25
      echo "Running DNS Perf to generate alot of ligitimate DNS traffic from Nominum sample data, to the DNS Server. \r\n \r\n"
      sudo dnsperf -s $server_ip -d queryfile-example-current -c 200 -T 10 -l 300 -q 10000 -Q $queries_ps 2> /dev/null &
      wait
fi

if [ -f test.net.txt ]
then
      echo "Running custom created DNS Perf script, which generates alot of benign traffic. \r\n \r\n "
      sudo dnsperf -s $server_ip -d test.net.txt -b 100000  -t 2 -c 100 -q 100000 -l 300 2> /dev/null &
fi
