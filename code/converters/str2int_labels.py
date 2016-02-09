import sys

if len(sys.argv) != 2:
	print "usage: " + sys.argv[0] + " <input_file>"
	sys.exit(1)

ifile = open(sys.argv[1])
ofile = open(sys.argv[1].split('.')[0] + ".out",'w')

labels = [line.strip() for line in ifile]
uniques = list(set(labels))
int_labels = [str(uniques.index(lbl) + 1) for lbl in labels]
ofile.write('\n'.join(int_labels))

ifile.close()
ofile.close()