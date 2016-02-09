# get hitting times
import sys
from numpy import *

# class graph
class graph:
	# function construct adjacency matrix
	def __init__(self, edge_list_file, directed):
		# form adjacency matrix
		line_num = 0
		for line in edge_list_file:
			line_num += 1
			if line_num == 1:
				self.num_vertices = int(line.strip())
			else:
				if line_num == 2:
					self.adj = zeros((self.num_vertices, self.num_vertices))
				src,dest,wt = [float(num) for num in line.strip().split()]	
				self.adj[src][dest] = wt
				if not directed:
					self.adj[dest][src] = wt
		# get other graph matrices
		self.indeg = self.get_in_degree()
		self.outdeg = self.get_out_degree()
		self.trans = self.get_transition()

	def get_out_degree(self):
		return self.adj.sum(1)

	def get_in_degree(self):
		return self.adj.sum(0)

	def get_transition(self):
		trans = zeros((self.num_vertices, self.num_vertices))
		for rownum in range(self.num_vertices):
			trans[rownum] = divide(self.adj[rownum],self.outdeg[rownum])
		return trans

	def get_hitting_dists(self, dest):
		A = diagflat(ones([self.num_vertices])) - self.trans
		A[dest] = 0
		A[dest][dest] = 1
		B = ones([self.num_vertices])
		B[dest] = 0
		return linalg.solve(A,B)

	def get_hitting_matrix(self):
		mat = zeros((self.num_vertices, self.num_vertices))
		for i in range(self.num_vertices):
			mat[i] = self.get_hitting_dists(i)
		return mat.transpose()

	def get_commute_affinity(self,k,labels):
		hitting_mat = self.get_hitting_matrix()
		affinity = zeros((self.num_vertices,k))
		for src in range(self.num_vertices):
			print "Percentage completed: " + str(float(src)/float(self.num_vertices)*100) + "%" 
			for cluster in range(k):
				members = where(labels==cluster)[0]
				members = delete(members, where(members==src))
				A = diagflat(ones([self.num_vertices])) - self.trans
				B = ones([self.num_vertices])
				for mem in members:
					A[mem] = 0
					A[mem][mem] = 1
					B[mem] = hitting_mat[mem][src]
					affinity[src][cluster] = linalg.solve(A,B)[src]
		return affinity

# read labels from a file
def read_labels(filename):
	content = open(filename)
	l = []
	for line in content:
		l.append(int(line.strip()))
	return array(l)

# main
if len(sys.argv) < 2:
	print "Usage: sys.argv[0] <edge_list>"
	sys.exit(1)

edge_list_file = open(sys.argv[1].strip())
G = graph(edge_list_file, False)
print "Graph created"
X = G.get_commute_affinity(10, read_labels('mnistlabels.csv'))
savetxt("affinity2.csv", X, delimiter=",")