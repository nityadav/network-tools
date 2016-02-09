# given a edge-weight graph we find out the truncated hitting affinity
import sys, random
from numpy import *

# class graph
class graph:
	# init function to construct edge_map
	def __init__(self, edge_list_file, directed):
		self.edge_map = {}
		self.directed = directed
		try:
			file_content = open(edge_list_file)
		except IOError:
			print "Unable to open the graph file."
		else:
			line_num = 0
			for line in file_content:
				line_num += 1
				if line_num == 1:
					self.num_vertices = int(line.strip())
					continue
				parts = line.strip().split()
				v1 = int(parts[0])
				v2 = int(parts[1])
				try:
					w = float(parts[2])
				except IndexError:
					w = 1.0
				self.add_edge(v1,v2,w)
			file_content.close()
			self.add_move_probs()
			self.hitting_dist = zeros((self.num_vertices, self.num_vertices))

	def add_edge(self,v1,v2,w):
		if v1 not in self.edge_map:
			self.edge_map[v1] = [[],[],[]]
		self.edge_map[v1][0].append(v2)
		self.edge_map[v1][1].append(w)
		if not self.directed:
			if v2 not in self.edge_map:
				self.edge_map[v2] = [[],[],[]]
			self.edge_map[v2][0].append(v1)
			self.edge_map[v2][1].append(w)

	def add_move_probs(self):
		for vertex in self.edge_map.keys():
			info = self.edge_map[vertex]
			self.edge_map[vertex][2] = [wt/sum(info[1]) for wt in info[1]]

	def random_move(self, src):
		return self.edge_map[src][0][array(self.edge_map[src][2]).cumsum().searchsorted(random.sample(1))[0]]

	def walk(self, src, length):
		walk = [src]
		curr = src
		for step in range(1,length+1):
			curr = self.random_move(curr)
			walk.append(curr)
		print walk

# main
if len(sys.argv) < 2:
	print "Usage: sys.argv[0] <edge_list>"
	sys.exit(1)

G = graph(sys.argv[1].strip(), False)
print "Graph created"
G.walk(0,7)


