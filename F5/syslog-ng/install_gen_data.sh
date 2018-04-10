
#-- Install DNS-Perf --
# https://www.nominum.com/measurement-tools/

apt-get install libbind-dev libkrb5-dev libssl-dev libcap-dev libxml2-dev 
apt-get install bind9utils make

cd /home/ubuntu/
wget ftp://ftp.nominum.com/pub/nominum/dnsperf/2.1.0.0/dnsperf-src-2.1.0.0-1.tar.gz

tar xfvz dnsperf-src-2.1.0.0-1.tar.gz
cd dnsperf-src-2.1.0.0-1
./configure
make
sudo make install

dnsperf -h

#--- download latest Queryfile from Nominum ---
wget ftp://ftp.nominum.com/pub/nominum/dnsperf/data/queryfile-example-current.gz
gunzip queryfile-example-current.gz

#---------------------------------------------------------------------------------------


