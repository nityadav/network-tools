from collections import defaultdict

net_file = open('network.txt')
com_file = open('community.txt')
adj_file = open('adj.csv','w')
lbl_file = open('lbl.csv','w')

edge_map = defaultdict(list)
for line in net_file:
	parts = line.strip().split()
	edge_map[int(parts[0])].append(int(parts[1]))

num_vertices = max(edge_map.keys()) + 1
for i in range(num_vertices):
	adj_line = ['0']*num_vertices
	for j in edge_map[i]:
		adj_line[j] = '1';
	adj_file.write(','.join(adj_line) + '\n')

labels = [0]*num_vertices
for com,line in enumerate(com_file):
	for v in line.strip().split():
		labels[int(v)] = str(com + 1)
missed = [i for i,l in enumerate(labels) if l==0]
print missed
lbl_file.write('\n'.join(labels) + '\n')

net_file.close()
com_file.close()
adj_file.close()
lbl_file.close()