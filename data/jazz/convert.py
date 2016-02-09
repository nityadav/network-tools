from collections import defaultdict

inp = open('jazz.net')
out = open('jazz.csv','w')

edge_map = defaultdict(list)
for line in inp:
	parts = line.strip().split()
	edge_map[int(parts[0]) - 1].append(int(parts[1])-1)
	edge_map[int(parts[1]) - 1].append(int(parts[0])-1)

num_vertices = max(edge_map.keys()) + 1
for i in range(num_vertices):
	adj_line = ['0']*num_vertices
	for j in edge_map[i]:
		adj_line[j] = '1';
	out.write(','.join(adj_line) + '\n')