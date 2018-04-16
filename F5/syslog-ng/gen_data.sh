#Clean traffic: 
dnsperf -s 10.10.0.50 -d ~/query-file-example-current -c 200 -T 10 -l 300 -q 10000 -Q 25

wait
wait
#Flood: 
dnsperf -s 10.10.0.50 -d ~/query-file-example-current -c 200 -T 10 -l 300 -q 10000 -Q 1000


# Webflow
./slowhttptest -c 1000 -B -g -o my_body_stats -i 110 -r 200 -s 8192 -t FAKEVERB -u https://myseceureserver/resources/loginform.html -x 10 -p 3


