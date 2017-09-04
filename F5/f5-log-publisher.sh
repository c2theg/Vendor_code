# Create Log Publisher
# Made by  Fred Wittenberg |  Systems Engineer | E: Fred @ F5.com
# Modified by: Christopher Gray | E: christophermjgray @ gmail.com
# 1/1/17  - 9/4/17
#
# 1) SSH into BigIP
# 2) from TMSH, paste the following. Please modify for your needs
#
#  THIS USES:  TCP : 1520 currently
#------------------------------------------------------------------

create ltm node logcollector.example.com fqdn { autopopulate enabled name logcollector.example.com down-interval 2 interval 15 } monitor /Common/icmp


#Create HSL Pool
create ltm pool Log-Pool-logcollector.example.com  members add { logcollector.example.com:1520 } monitor gateway_icmp


#Create Log Destinations
create sys log-config destination remote-high-speed-log Log-Destination-logcollector.example.com pool-name Log-Pool-logcollector.example.com protocol tcp distribution balanced
create sys log-config destination splunk Log-Destination-logcollector.example.com-SPLUNK forward-to Log-Destination-logcollector.example.com


#Create log publishers
create sys log-config publisher Log-Publisher-logcollector.example.com destinations add { Log-Destination-logcollector.example.com-SPLUNK }


#Build ASM DOS logging filter
create security log profile Logging-Profile-logcollector.example.com application add { Logging-logcollector.example.com }


#Add BOT defense to ASM DOS logging filter
modify security log profile Logging-Profile-logcollector.example.com {bot-defense add { Logging-Profile-logcollector.example.com { filter { log-challenged-requests enabled log-illegal-requests enabled log-legal-requests enabled } local-publisher local-db-publisher remote-publisher Log-Publisher-logcollector.example.com } } }


modify security log profile Logging-Profile-logcollector.example.com {bot-defense add { Logging-Profile-logcollector.example.com { filter { log-challenged-requests enabled log-illegal-requests enabled log-legal-requests enabled } local-publisher local-db-publisher remote-publisher Log-Publisher-logcollector.example.com } } }


#Add Application-DOS to ASM DOS logging filter
modify security log profile Logging-Profile-logcollector.example.com { dos-application add { Logging-Profile-logcollector.example.com { local-publisher local-db-publisher remote-publisher Log-Publisher-logcollector.example.com } } }
