#!/usr/bin/python
# used to convert adj.csv to adj.net to an edge list with vertices numbered from 0
import sys

adj_file = open(sys.argv[1].strip())
edge_list = []
for line in adj_file:
	edge_list.append([v for v,wt in enumerate(line.split(',')) if wt.strip() is not '0'])
edge_file = open(sys.argv[2].strip(),'w')
for u,nbrs in enumerate(edge_list):
	for v in nbrs:
		edge_file.write(str(u) + " " + str(v) + "\n")
adj_file.close()
edge_file.close()