#simple python ping sweep

import os

print("Let's throw some icmp around. You can't do more than a `/24.")
rangeStart = raw_input("Which ip should we start with? ")
subnet, startIp = rangeStart.rsplit(".",1)
rangeEnd = raw_input("Which ip should we stop at? ")
subnet, endIp = rangeEnd.rsplit(".",1)

for x in range (startIp, endIp)
	print(x)

