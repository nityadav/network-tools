#!/usr/bin/python
import re
import sys

n = sys.argv[1]

lbl = [0]*int(n)
com_file = open(sys.argv[2].strip())
lines = com_file.readlines()
k = 1
for line in reversed(lines):
	if not line.startswith("community"):
		break
	com_str = re.search(r'\{(.*)\}',line).group(1)
	for v in com_str.split(','):
		lbl[int(v.strip())] = str(k)
	k += 1
lbl_file = open(sys.argv[3].strip(),'w')
lbl_file.write('\n'.join(lbl))
lbl_file.close()