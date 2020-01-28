#!/bin/bash
#ping sweep, enumerate services, then lookup exploits
#parameter one is the start of range, 2 is the end of the range
#example: ./pingsweep.sh [starting ip] [ending ip] [output file]
#won't span /24

read -p "What ip should we start with? " startRange
read -p "What ip should we end with? Keep the range smaller than /24. " endRange
read -p "What dir do you want the output in? " outDir

network=$(echo $startRange| cut -d '.' -f1,2,3)
host=$(echo $startRange| cut -d '.' -f4)
endHost=$(echo $endRange| cut -d '.' -f4)
unsortedps=$outDir/unsortedps.txt
touch $unsortedps
outFile=$outDir/pingsweep.txt
touch $outFile

until [ $host -gt $endHost ]; do
	ip=$network.$host
	(ping -c 1 $ip| grep "bytes from"| cut -d " " -f4| cut -d ":" -f1 >> $unsortedps)&
	let "host++"
done
wait
cat $unsortedps| sort -n -t . -k 1,1 -k 2,2 -k 3,3 -k 4,4 > $outFile

#nmap hosts from output of ping sweep, pull exploits from searchsploit

ips=`cat $outDir/pingsweep.txt`

for ip in $ips; do
	nmapOutFile=$outDir/$ip.xml
	(nmap $ip -sV -O -oX $nmapOutFile
	searchsploit -v --nmap $nmapOutFile > $outDir/$ipExploits.txt)&
done
wait
