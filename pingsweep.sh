#!/bin/bash
#a simple ip sweep
#parameter one is the start of range, 2 is the end of the range
#example: ./pingsweep.sh [starting ip] [ending ip]
#won't span /24

network=$(echo $1| cut -d '.' -f1,2,3)
host=$(echo $1| cut -d '.' -f4)
endHost=$(echo $2| cut -d '.' -f4)

until [ $host -gt $endHost ]; do
	ip=$network.$host
	(ping -c 1 $ip| grep "bytes from"| cut -d " " -f4| cut -d ":" -f1)&
	#echo $ip
	let "host++"
	#echo $host
done
wait
