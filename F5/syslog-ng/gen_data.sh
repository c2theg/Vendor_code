#Clean traffic: 
dnsperf -s 10.10.0.50 -d ~/query-file-example-current -c 200 -T 10 -l 300 -q 10000 -Q 25

wait
wait
#Flood: 
dnsperf -s 10.10.0.50 -d ~/query-file-example-current -c 200 -T 10 -l 300 -q 10000 -Q 1000


