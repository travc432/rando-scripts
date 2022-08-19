# Deobfuscating file
# The idea is to look for hex in /x00 notation
# and in 0x00 notation and convert it to ascii.
# later developements may be looking for base64 or simplifying js snippets
# Author: Travis Crotteau

import re
import sys

file_name = sys.argv[1]
# define regex patterns
slash_x_hex_pattern = re.compile(r'(\\[xX])([0-9a-fA-F]{2})')
zero_x_hex_pattern = re.compile(r'(0[xX])([0-9a-fA-F]*)')

# get code from cmdline arg
obf_file = open(sys.argv[1], 'r')
# casting as string might be rundundant
code = str(obf_file.read())
obf_file.close()

# DEBUG - check for string type
print("script_start", type(code))


def slash_x_replace():
    print("Found \\x formatted hex. Decoding...")
    global code
    # DEBUG check code type (look for str) and check hex found
    print("slash_x_replace_", type(code))
    # build deobfuscated hex
    code = re.sub(slash_x_hex_pattern, lambda x: bytes.fromhex(x.group(2)).decode("utf-8"), code)
    # DEBUG - check code type
    print("slash_x_replace_after_replace", type(code))
    hex_search()

    # function for searching and replace 0x000 formatted hex


def zero_x_replace():
    print("Found 0x00 formatted hex.  Decoding...")
    global code
    # DEBUG - check for type
    print("zero_x_replace", type(code))
    print(str((re.search(zero_x_hex_pattern, code).group(2))))
    # build deobfuscated he
    code = re.sub(zero_x_hex_pattern, lambda x: bytes.fromhex(x.group(2)).decode("utf-8"), code)
    # DEBUG - check for type
    print("zero_x_replace_after_replace", type(code))
    hex_search()

    # searches for match and then run function to convert text


def hex_search():
    global code
    if slash_x_hex_pattern.search(code):
        slash_x_replace()
    elif zero_x_hex_pattern.search(code):
        zero_x_replace()
    else:
        print("No hex found this time. Creating deobf_code.txt.")
        dump_deobf_code()


# dumps code to file
def dump_deobf_code():
    global code
    # DEBUG - check type again
    print("before_file_dump", type(code))
    # dump deobfuscated code to file
    deobf_file = open("deobf_code.txt", "w")
    deobf_file.write(code)
    deobf_file.close()
    print("Deobfuscated file created.")
    quit()


hex_search()
