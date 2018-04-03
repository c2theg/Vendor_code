The following scripts will download, setup, and configure the software. <br /><br />

Getting Started: <br />
<ul>
  <li><b>Install Elastic Stack (v6): </b><br />
    wget https://raw.githubusercontent.com/c2theg/srvBuilds/master/install_elk6.sh && chmod u+x install_elk6.sh && ./install_elk6.sh

  </li>
  
  <li>
    <b>Install F5 config: </b><br />
wget https://raw.githubusercontent.com/c2theg/Vendor_code/master/F5/syslog-ng/provision.sh && chmod u+x provision.sh && ./provision.sh
  </li>
</ul>

<br /><br /><br />
To update ElasticSearch plugins, Logstash plugins, (including GeoIP databases from Maxmind)
https://raw.githubusercontent.com/c2theg/Vendor_code/master/F5/syslog-ng/update_elk_plugins.sh


<br /><br />
Add to crontab (will update every Wednesday at 4:05am) <br /><br />
<b>  5 4 * * 3 /home/ubuntu/update_elk_plugins.sh >> /var/log/update_elk_plugins.log 2>&1  </b>
