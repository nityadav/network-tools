def find600():
	f = open("comm_sizes.txt")
	m34 = 3520
	s1 = [int(l.strip()) for l in f]
	s2 = [abs(i - m34) for i in s1]
	comm = sorted(range(1,len(s2)+1,1), key = lambda i: s2[i-1])[0:600]
	# print [s1[i-1] for i in comm]
	o = open("top600.txt","w")
	for i in comm:
		o.write(str(i) + "\n")
	o.close()

find600()