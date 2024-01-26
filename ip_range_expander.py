"""
ip_range_expander.py:
Intended to take ranges of ip in this format x.x.x.x-x.x.x.x and expand it to a full list
"""
___author___    = "Travis Crotteau"

import os
import sys

output_file = open("output.txt","x")

# maybe replace this with a parameter later
with open('qualys_ranges.txt') as ranges_file:
    # for each line, create variables for the starting ip, ending ip,
    # and the first three octets of each.
    for line in ranges_file:
        ip_range = line.split("-")
        start_ip = ip_range[0].strip()
        end_ip = ip_range[1].strip()
        start_ip_octets = start_ip.split('.')
        end_ip_octets = end_ip.split('.')
        start_ip_first_three = start_ip_octets[0] \
                                  + "." + start_ip_octets[1] \
                                  + "." + start_ip_octets[2]
        end_ip_first_three = end_ip_octets[0] \
                                  + "." + end_ip_octets[1] \
                                  + "." + end_ip_octets[2]
        start_ip_last_oct = int(start_ip_octets[-1])
        end_ip_last_oct = int(end_ip_octets[-1])

        # compare the first three octets of start and end ip to make sure they match
        # might work up differing octets later
        
        if start_ip_first_three == end_ip_first_three:
            for i in range(start_ip_last_oct,(end_ip_last_oct + 1)):
                output_file.write(start_ip_first_three + '.' + str(i) + "\n")
        else:
            output_file.write(start_ip + "doesn't match" + end_ip + "\n")

sys.exit
