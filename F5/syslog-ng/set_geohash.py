#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#----------------------------------------------------------
#  * Copyright (c) 2018-2019 Christopher Gray
#
#  * Requirements:
#   Install pip and requests.
#       sudo apt-get install python3-pip 
#       pip3 install --upgrade pip
#       pip3 install requests
#----------------------------------------------------------
Info = """
Version: 0.0.5
Updated: 5/16/19
"""
#----Standard Libs---------
import sys, os, argparse, json
#---End of Standard libs---
from pprint import pprint
import logging
import requests
from requests.auth import HTTPDigestAuth
from requests.exceptions import HTTPError
#------------------------------------------------------------------------------
if __name__ == '__main__':
    headers = {'content-type': 'application/json'}

    try:
        import httplib
    except ImportError:
        import http.client as httplib

    httplib.HTTPConnection.debuglevel = 1
    logging.basicConfig(level=logging.DEBUG) # you need to initialize logging, 

    try:
        BigIQ_URL = input("Enter BigIQ Mgmt URL or IP:  ")
        if BigIQ_URL is None:
            print ("\r\nYou have to enter an BigIQ Mgmt URL or IP address before continuing \r\n")
            sys.exit(0)
    except OSError:
        pass
        
    try:
        BigIQ_Username = input("Enter Username:  ")
        if BigIQ_Username is None:
            print ("\r\nYou have to enter the username before continuing \r\n")
            sys.exit(0)
    except OSError:
        pass

    try:
        BigIQ_Password = input("Enter Password:  ")
        if BigIQ_Password is None:
            print ("\r\nYou have to enter the password before continuing \r\n")
            sys.exit(0)
    except OSError:
        pass
                        
    #-----------------------------------------------------------------------------------------------------------
    URL = 'https://' + BigIQ_URL  + '/mgmt/shared/resolver/device-groups/cm-bigip-allBigIpDevices/devices/'
    try:    
        r = requests.get(URL, auth=HTTPDigestAuth(BigIQ_Username, BigIQ_Password), headers=headers, timeout=20, verify=False, stream=True)
    except HTTPError as http_err:
        print("HTTP error occurred: " + str(http_err))
        sys.exit(0)
    except Exception as err:
        print("Other error occurred: " + str(err))
        sys.exit(0)

    #-----------------------------------------------------------------------------------------------------------
    if r.status_code == 200:
        results = r.json()
        pprint("Here is a list of all the devices you currently are managed by the BigIQ: \r\n \r\n " + results)
        #-----------------------------------------------------------------------------------------------------------
        try:
            BigIP_UUID = input("Enter the BigIP's UUID you care to update. (IE: c475c10e-cf9e-403c-8b66-c1418faffexx):  ")
            if BigIP_UUID is None:
                print ("\r\nYou have to enter an UUID before continuing \r\n")
                sys.exit(0)
        except OSError:
            pass

        try:
            BigIP_LocationName = input("Enter the BigIPs' location name you want to update the BigIQ with. (IE: Seattle_DC1):  ")
            if BigIP_LocationName is None:
                print ("\r\nYou have to enter the locations' name before continuing \r\n")
                sys.exit(0)
        except OSError:
            pass

        try:
            BigIP_GeoHash = input("Enter the GeoHash you want to update the BigIQ with. (Go to: http://geohash.gofreerange.com/ to get this):  ")
            if BigIP_GeoHash is None:
                print ("\r\nYou have to enter a GeoHash before continuing \r\n")
                sys.exit(0)
        except OSError:
            pass
        #-----------------------------------------------------------------------------------------------------------
        #head = {"Authorization":"Token token=xxxxxxxxxxxxxxxxxxxxxx"}
        URL = 'https://' + BigIQ_URL  + '/mgmt/shared/resolver/device-groups/cm-bigip-allBigIpDevices/devices/' + BigIP_UUID
        payload = { "dataCenterName": BigIP_LocationName,  "dataCenterLocation": BigIP_GeoHash }
        try:
            r = requests.patch(URL, payload, auth=HTTPDigestAuth(BigIQ_Username, BigIQ_Password), headers=headers, timeout=20, verify=False, stream=True)
        except HTTPError as http_err:
            print("HTTP error occurred: " + str(http_err))
            sys.exit(0)
        except Exception as err:
            print("Other error occurred: " + str(err))
            sys.exit(0)
        #-----------------------------------------------------------------------------------------------------------
        if r.status_code == 200:
            results = r.json()
            pprint("Done. Here is the results: \r\n \r\n " + results + "\r\n \r\n")
        else:
            print('An error has occurred.')                
    else:
        print('An error has occurred.')

"""
------- INFO ------
GET the device uuid:
Request:
 
https://10.241.209.10/mgmt/shared/resolver/device-groups/cm-bigip-allBigIpDevices/devices/
Response:
 
{
    "items": [
        {
            "address": "10.241.209.12",
            "build": "0.0.2187",
            "deviceUri": "https://10.241.209.12:443",
            "edition": "Final",
            "generation": 6,
            "groupName": "cm-bigip-allBigIpDevices",
            "hostname": "bigip_10-241-209-12.f5net.com",
            "httpsPort": 443,
            "isClustered": false,
            "isLicenseExpired": false,
            "isVirtual": true,
            "kind": "shared:resolver:device-groups:restdeviceresolverdevicestate",
            "lastUpdateMicros": 1541409458873324,
            "machineId": "c475c10e-cf9e-403c-8b66-c1418faffeeb",
            "managementAddress": "10.241.209.12",
            "mcpDeviceName": "/Common/bigip1",
            "product": "BIG-IP",
            "properties": {
                "shared:resolver:device-groups:discoverer": "f904bd97-9ea3-4144-a1ac-2eef44f7bc26"
            },
            "restFrameworkVersion": "14.0.0-0.0.2187",
            "selfLink": "https://localhost/mgmt/shared/resolver/device-groups/cm-bigip-allBigIpDevices/devices/c475c10e-cf9e-403c-8b66-c1418faffeeb",
            "slots": [
                {
                    "volume": "HD1.1",
                    "product": "BIG-IP",
                    "version": "13.1.0.5",
                   "build": "0.0.5",
                    "isActive": false
                },
                {
                    "volume": "HD1.2",
                    "product": "BIG-IP",
                    "version": "14.0.0",
                    "build": "0.0.2187",
                    "isActive": true
                }
            ],
            "state": "ACTIVE",
            "tags": [
                {
                    "name": "BIGIQ_tier_1_device",
                    "value": "2018-10-23T15:12:57.573+03:00"
                }
            ],
            "uuid": "c475c10e-cf9e-403c-8b66-c1418faffeeb",
            "version": "14.0.0"
        }
    ],
    "generation": 2,
    "kind": "shared:resolver:device-groups:devicegroupdevicecollectionstate",
    "lastUpdateMicros": 1541409458923909,
    "selfLink": "https://localhost/mgmt/shared/resolver/device-groups/cm-bigip-allBigIpDevices/devices"
}
 
 
PATCH the datacenter properties:
 
Request:
 
https://10.241.209.10/mgmt/shared/resolver/device-groups/cm-bigip-allBigIpDevices/devices/c475c10e-cf9e-403c-8b66-c1418faffeeb
 
Request body:
 
{
   "dataCenterName":"Tokyo Data Center",
   "dataCenterLocation":"xn775d"
}
 
Then I enabled the stats recording as described to verify that this info is shown in the recording log:
 
                "timestamp": 1542222003146,
                "listener": "avr_stat_http",
                "ipAddress": "c475c10e-cf9e-403c-8b66-c1418faffeeb_10.241.209.12",
                "payload": "Hostname=\"bigip_10-241-209-12.f5net.com\",SlotId=\"0\",errdefs_msgno=\"22323211\",STAT_SRC=\"TMSTAT\",Entity=\"TcpStat\",EOCTimestamp=\"1542222000\",AggrInterval=\"300\",HitCount=\"30\",tcp_prof=\"/Common/tcp\",vip=\"/Common/vs1Dummy\",dataCenterLocation=\"xn775d\",dataCenterName=\"Tokyo Data Center\",deviceAddress=\"10.241.209.12\",deviceHostname=\"bigip_10-241-209-12.f5net.com\",deviceIsClustered=\"false\",deviceIsVirtual=\"true\",dnsSyncGroup=\"syncgroup1\",ObjectTagsList=\"N/A\",active_conns=\"0\",max_active_conns=\"0\",accepts=\"0\",accept_fails=\"0\",new_conns=\"0\",failed_conns=\"0\",expired_conns=\"0\",abandoned_conns=\"0\",rxrst=\"0\",rxbadsum=\"0\",rxbadseg=\"0\",rxooseg=\"0\",rxcookie=\"0\",rxbad_cookie=\"0\",hw_cookie_valid=\"0\",syncacheover=\"0\",txrexmits=\"0\",sndpack=\"0\""
 """
