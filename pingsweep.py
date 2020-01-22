#simple python ping sweep

import os

print "Let's throw some icmp around. You can't do more than a `/24."
rangeStart = raw_input("Which ip should we start with? ")
subnet, startIp = rangeStart.rsplit(".",1)
rangeEnd = raw_input("Which ip should we stop at? ")
subnet, endIp = rangeEnd.rsplit(".",1)

for x in range(int(startIp), (int(endIp)+1)):
	ip = (subnet+"."+str(x))
	response = os.system("ping -c 1 " + ip + " > /dev/null 2>&1")
	if response == 0:
		print ip, "responded."
