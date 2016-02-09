from graph_tool.all import *
from sklearn import metrics
from scipy.sparse import csr_matrix
import time, random
import numpy as np

"""
There are some recognized names for the properties of the graph:
weight: denotes weight of the edges and is always present.
label: denotes the label after the graph has been clustered.
num_clusters: denotes the number of clusters the graph has been clustered into
"""
class gt_graph:
	def load_from_csv(self, csvfilename, if_directed):
		linecount = 0
		edgemap = {}
		csvfile = open(csvfilename)
		for line in csvfile:
			row = [item.strip() for item in line.strip().split(',')]
			row = filter(None,row)
			edgemap[linecount] = {}
			for col,weight in enumerate(row):
				weight = int(weight)
				if weight != 0:
					edgemap[linecount][col] = weight
			linecount += 1
		self.graph = Graph(directed=if_directed)
		self.graph.add_vertex(linecount)
		# create an edge property
		self.weight = self.graph.new_edge_property('double')
		for source in edgemap.keys():
			weights = edgemap[source]
			for neighbor in weights.keys():
				if if_directed:
					self.graph.add_edge(self.graph.vertex(source), self.graph.vertex(neighbor))
					self.weight[self.graph.edge(source,neighbor)] = weights[neighbor]
				else:
					if source < neighbor:
						self.graph.add_edge(self.graph.vertex(source), self.graph.vertex(neighbor))
						self.weight[self.graph.edge(source,neighbor)] = weights[neighbor]
		# make the edge property internal to graph
		self.graph.edge_properties['weight'] = self.weight
		csvfile.close()
		out_deg = self.graph.new_vertex_property('int')
		for u in self.graph.vertices():
			out_deg[u] = u.out_degree()
		self.graph.vertex_properties['out_deg'] = out_deg

	def load_from_gml(self, gmlfilename):
		self.graph = load_graph(gmlfilename)
		if 'weight' not in self.graph.edge_properties:
			self.weight = self.graph.new_edge_property('double')
			for edge in self.graph.edges():
				self.weight[edge] = 1.0
		out_deg = self.graph.new_vertex_property('int')
		for u in self.graph.vertices():
			out_deg[u] = u.out_degree()
		self.graph.vertex_properties['out_deg'] = out_deg

	def load_from_graphml(self, graphmlfilename):
		self.graph = load_graph(graphmlfilename)
		if 'weight' not in self.graph.edge_properties:
			self.weight = self.graph.new_edge_property('double')
			for edge in self.graph.edges():
				self.weight[edge] = 1.0
		out_deg = self.graph.new_vertex_property('int')
		for u in self.graph.vertices():
			out_deg[u] = u.out_degree()
		self.graph.vertex_properties['out_deg'] = out_deg

	def load_known(self, name):
		self.graph = collection.data[name]
		out_deg = self.graph.new_vertex_property('int')
		for u in self.graph.vertices():
			out_deg[u] = u.out_degree()
		self.graph.vertex_properties['out_deg'] = out_deg

	def save_graph(self, filename):
		self.graph.save(filename, fmt='graphml')

	def draw_graph(self, filename):
		if 'pos' not in self.graph.vertex_properties:
			# draw the graph using ARF layout
			vertex_pos = arf_layout(self.graph, max_iter=0)
			self.graph.vertex_properties['pos'] = vertex_pos
			#vertex_pos = sfdp_layout(self.graph)
		else:
			vertex_pos = self.graph.vertex_properties['pos']
		grey = [0,0,0,0.4]
		if 'max_affinity' in self.graph.vertex_properties:
			graph_draw(self.graph, pos=vertex_pos, vertex_fill_color=self.graph.vertex_properties['cluster'], vertex_size=self.graph.vertex_properties['max_affinity'], edge_color=grey, output=filename)
		elif 'cluster' in self.graph.vertex_properties:
			graph_draw(self.graph, pos=vertex_pos, vertex_fill_color=self.graph.vertex_properties['cluster'], vertex_size=15, edge_color=grey, output=filename)
		else:
			# do the simple drawing
			graph_draw(self.graph, pos=vertex_pos, output=filename)

	def read_cluster(self, filename):
		cluster = self.graph.new_vertex_property('int')
		content = open(filename);
		vertex_num = 0
		for line in content:
			cluster[self.graph.vertex(vertex_num)] = int(line.strip())
			vertex_num += 1;
		self.graph.vertex_properties['cluster'] = cluster
		num_clusters = self.graph.new_graph_property('int')
		self.graph.graph_properties['num_clusters'] = num_clusters
		self.graph.graph_properties['num_clusters'] = len(set(cluster.get_array()))
		content.close()

	def read_pos(self, filename):
		vertex_pos = self.graph.new_vertex_property('vector<double>')
		content = open(filename);
		vertex_num = 0
		for line in content:
			vertex_pos[self.graph.vertex(vertex_num)] = [float(v_pos) for v_pos in line.strip().split(',')]
			vertex_num += 1
		# this overrides previous vertex positions
		self.graph.vertex_properties['pos'] = vertex_pos
		content.close()

	def read_max_affinity(self, filename):
		max_affinity = self.graph.new_vertex_property('double')
		content = open(filename);
		vertex_num = 0
		for line in content:
			max_affinity[self.graph.vertex(vertex_num)] = float(line.strip())
			vertex_num += 1
		# this overrides previous calculations and assignments of affinities
		self.graph.vertex_properties['max_affinity'] = max_affinity
		content.close()

	def write_adj(self, filename):
		content = open(filename,'w')
		for u in self.graph.vertices():
			row = [str(int(self.graph.edge(u,v) is not None)) for v in self.graph.vertices()]
			content.write(",".join(row) + '\n')
		content.close()

	def write_lbl(self, filename, prop_name):
		content = open(filename,'w')
		prop = self.graph.vertex_properties[prop_name]
		for v in self.graph.vertices():
			content.write(str(prop[v]) + '\n')
		content.close()

	def get_subgraph(self, vertex_list):
		subgraph = Graph()
		subgraph.add_vertex(len(vertex_list))
		for i,u in enumerate(vertex_list):
			for j,v in enumerate(vertex_list):
				if self.graph.edge(u,v):
					subgraph.add_edge(i,j)
		return subgraph

	def do_clustering(self):
		state = minimize_blockmodel_dl(self.graph)
		self.graph.vertex_properties['cluster'] = state.b
		num_clusters = self.graph.new_graph_property('int')
		self.graph.graph_properties['num_clusters'] = num_clusters
		self.graph.graph_properties['num_clusters'] = len(set(state.b.get_array()))

	def do_k_clustering(self, k):
		state = BlockState(self.graph, B=k, deg_corr=True)
		for i in range(10000):
			ds, nmoves = mcmc_sweep(state)
		self.graph.vertex_properties['cluster'] = state.b
		num_clusters = self.graph.new_graph_property('int')
		self.graph.graph_properties['num_clusters'] = num_clusters
		self.graph.graph_properties['num_clusters'] = k
		self.write_lbl('lbl_' + str(k) + '.csv', 'cluster')

	def get_members(self, cluster_num):
		label = self.graph.vertex_properties['cluster']
		vertex_list = [v for v in self.graph.vertices() if label[v] == cluster_num]
		return vertex_list

	def compute_mod_affinity(self):
		if 'cluster' not in self.graph.vertex_properties:
			self.do_clustering()
		# now compute affinity vectors
		k = self.graph.graph_properties['num_clusters']
		label = self.graph.vertex_properties['cluster']
		twice_m = float(2*self.graph.num_edges())
		affinity = self.graph.new_vertex_property('vector<double>')
		for c in range(k):
			mem_c = self.get_members(c)
			for v in self.graph.vertices():
				deg = float(v.out_degree())
				deg_vc = float(len([nbr for nbr in v.out_neighbours() if label[nbr] == c]))
				sum_deg_c = sum([mem.out_degree() for mem in mem_c if mem_c != v])
				affinity[v].append(deg_vc - (deg*sum_deg_c/twice_m))
		self.graph.vertex_properties['affinity'] = affinity
		# compute max-affinity
		max_affinity = self.graph.new_vertex_property('double')
		for v in self.graph.vertices():
			max_affinity[v] = max(affinity[v]) + 5
			print max_affinity[v]
		self.graph.vertex_properties['max_affinity'] = max_affinity
		# compute stability
		stability = self.graph.new_graph_property('double')
		self.graph.graph_properties['stability'] = stability
		self.graph.graph_properties['stability'] = sum(max_affinity.get_array())

	def get_cluster_coeff(self):
		print global_clustering(self.graph)

	# **************** This code below belongs to the amazon seed expansion experiment *******************
	# for using this method have a folder named amazon with files index.txt, edges.txt and communities.txt
	# vertices are not numbered contiguously from 1 to 334863, hence we need an index file
	def load_amazon_graph(self):
		try:
			index_file = open("amazon/index.txt")
			edgelist_file = open("amazon/edges.txt")
			comm_file = open("amazon/communities.txt")
		except:
			print "For using this method have a folder named amazon with files index.txt, edges.txt and communities.txt"
			return
		# create an index
		vert_index = {}
		for lin_num,val in enumerate(index_file):
			vert_index[val.strip()] = lin_num
		# create graph from reading the edges.txt
		self.graph = Graph(directed=False)
		self.graph.add_vertex(334863) # number of nodes in amazon graph
		header_mode = True
		for line in edgelist_file:
			line = line.strip()
			if line.startswith('#'):
				continue
			u,v = line.split()
			self.graph.add_edge(self.graph.vertex(vert_index[u]), self.graph.vertex(vert_index[v]))
		edgelist_file.close()
		# read the community data into a cluster property and also create a comm_num -> vertices list
		cluster = self.graph.new_vertex_property('int')
		community_list = []
		k = 1
		count = []
		for line in comm_file:
			community_list.append([])
			for v in line.split():
				cluster[self.graph.vertex(vert_index[v])] = k
				community_list[k-1].append(self.graph.vertex(vert_index[v]))
			k += 1
		self.graph.vertex_properties['cluster'] = cluster
		return community_list

	# seed_list is a list of vertices chosen as seed
	def pagerank_seed_expansion(self, seed_list):
		seed_len = len(seed_list)
		seed_val = 1.0/float(seed_len)
		pers_vector = self.graph.new_vertex_property('double')
		for v in self.graph.vertices():
			if v in seed_list:
				pers_vector[v] = seed_val
			else:
				pers_vector[v] = 0.0
		pagerank_vector = pagerank(self.graph, damping=0.90, pers=pers_vector, max_iter=5).get_array()
		return list(reversed(np.argsort(pagerank_vector).tolist()))

	# neighborhood seed-expansion
	def nbr_seed_expansion(self):
		start = time.time()
		sp_mat = adjacency(self.graph)
		sp_mat_sq = sp_mat*sp_mat
		end = time.time()
		print "time taken to get sparse matrix: " + str(end-start)

		start = time.time()
		# construct the sparse matrix for degrees
		n = self.graph.num_vertices()
		sp_deg = csr_matrix(())
		non_zero_inds = np.nonzero(sp_mat_sq)
		for ind in range(len(non_zero_inds[0])):
			i = non_zero_inds[0][ind]
			j = non_zero_inds[0][ind]

		end = time.time()
		print "time taken to construct nbr matrix: " + str(end-start)
		

	def seed_expansion_from_community(self, com_num, com_list, seed_size_fraction, k_list):
		com_verts_list = com_list[com_num-1]
		com_size = len(com_verts_list)
		seeds = random.sample(com_verts_list, int(com_size*seed_size_fraction))
		print "Doing expansion"
		expansion_result = self.pagerank_seed_expansion(seeds)[0:max(k_list)]
		flag = [0]*len(expansion_result)
		print "Finished expansion. Constructing the prediction set."
		# mark flag as 1 if the corresponding vertex in expansion_result is in community and is not in the seed set
		for ind,i in enumerate(expansion_result):
			v = self.graph.vertex(i)
			if (v not in seeds) and (v in com_verts_list):
				flag[ind] = 1
		print "Finished constructing the prediction set"
		# now loop across different values of k and get recalls
		recalls = []
		denom = float(com_size - len(seeds))
		for k in k_list:
			recalls.append("{:2.4f}".format(sum(flag[0:k])/denom))
		return recalls
	# **************** This code above belongs to the amazon seed expansion experiment *******************