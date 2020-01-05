#!/bin/bash
#lowFruit  
#nmap a host, pull exploits from searchsploit, grep remote
#Useage: lowFruit [targetIP] [outFile]

nmap $1 -sV -O -oX ${2}.xml
searchsploit -v --nmap ${2}.xml > ${2}Exploits.txt
echo -e "\nHere's the low hanging fruit...\n" 
cat ${2}Exploits.txt | grep remote 
