import sys

ifile = open(sys.argv[1])
ofile = open(sys.argv[2],'w')

lines = ifile.readlines()
lines = lines[1:]
labels = [0]*len(lines)
for line in lines:
	parts = line.strip().split()
	comm = parts[0].split(':')[0]
	vert = int(parts[2][2:-1])-1
	labels[vert] = comm
ofile.write("\n".join(labels) + "\n")
ofile.close()
ifile.close()