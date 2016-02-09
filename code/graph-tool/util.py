#/opt/local/bin/python2.7
import sys, gt_graph

# choice functions
def load_graphml(G):
	filepath = raw_input("Enter the graphml file path: ")
	G.load_from_graphml(filepath)
	print filepath + " loaded."

def load_csv(G):
	filepath = raw_input("Enter the csv file path: ")
	directed = bool(input("Is the graph directed (1/0)?: "))
	G.load_from_csv(filepath, directed)
	print filepath + " loaded."

def load_gml(G):
	filepath = raw_input("Enter the gml file path: ")
	G.load_from_gml(filepath)
	print filepath + " loaded."

def known_graph(G):
	name = raw_input("Enter the name (eg. karate, dolphins, lesmis, football): ")
	G.load_known(name.strip())

def work_with_csv(G):
	G.load_from_csv('adj.csv', False)
	G.read_cluster('lbl.csv')
	#G.read_pos('pos.csv')
	#G.read_max_affinity('aff.csv')
	G.draw_graph('drw.pdf')

def multiple_draw(G):
	G.load_from_csv('adj.csv', False)
	names = raw_input("Enter the filenames (separated by spaces) which have the labels: ")
	filenames = names.split()
	for files in filenames:
		G.read_cluster(files)
		G.draw_graph(files.split('.')[0] + '.pdf')

def list_props(G):
	G.graph.list_properties()

def compute_ppr(G):
	G.compute_ppr()

def save_graph(G):
	filename = raw_input("Enter the name of the file for saving the graph: ")
	G.save_graph(filename)

def draw_graph(G):
	filename = raw_input("Enter the name of the file for drawing the graph: ")
	G.draw_graph(filename)

def find_communities(G):
	G.do_clustering()

def compute_affinity(G):
	G.compute_affinity()

def read_label(G):
	filename = raw_input("Enter the name of the file for reading the label: ")
	G.read_cluster(filename)

def read_pos(G):
	filename = raw_input("Enter the name of the file for reading the label: ")
	G.read_pos(filename)

def read_max_affinity(G):
	filename = raw_input("Enter the name of the file for reading the max affinities: ")
	G.read_max_affinity(filename)

def write_graph(G):
	prop_name = raw_input("Enter the property name which denotes the label: ")
	G.write_adj('adj.csv')
	#G.write_lbl('lbl.csv',prop_name)

def clustering_coeff(G):
	G.get_cluster_coeff()

def k_clustering(G):
	k = int(raw_input("Enter the number of clusters: "))
	G.do_k_clustering(k)

def run_exp(G):
	experiment_dict = {1:amazon_seed_expansion}
	exp_num = int(raw_input("Enter the experiment number: "))
	experiment_dict[exp_num](G)

def amazon_seed_expansion(G):
	community_list = G.load_amazon_graph()
	print "Amazon graph loaded"
	G.nbr_seed_expansion()
	"""
	top600 = [int(line.strip()) for line in open("amazon/top600.txt")]
	#k_list = range(0,1450,50)
	k_list = [3520]
	recall_file = open("pagerank_recalls.csv","w")
	for c in top600[0:30]:
		print "Doing seed exapnsion experiment on community: " + str(c)
		recalls = G.seed_expansion_from_community(c,community_list,0.1,k_list)
		recall_file.write(",".join(recalls) + "\n")
	recall_file.close()
	"""

def main():
	graph_object = gt_graph.gt_graph()
	# loading the graph
	while True:
		print "Select your option:"
		print "0. Exit"
		print "1. Load graph from a file in graphml format"
		print "2. Load graph from adjacency matrix in csv format"
		print "3. Load graph from a file in gml format"
		print "4. Load a known graph"
		print "5. Load and draw csv (picks adj.csv, lbl.csv, pos.csv)"
		print "6. Draw with multiple labels"
		print "7. Run an experiment"
		try:
			choice = int(raw_input('Enter your choice: '))
		except:
			print "Wrong option entered."
			break
		else:
			choice_dict = {0:exit, 1:load_graphml, 2:load_csv, 3:load_gml, 4:known_graph, 5:work_with_csv, 6:multiple_draw, 7:run_exp}
			choice_dict.get(choice,-1)(graph_object)
			if choice == 0:
				sys.exit(0)
			elif choice in choice_dict.keys():
				break

	# processing the graph
	while True:
		print "Select your option:"
		print "0. Exit"
		print "1. List all the properties"
		print "2. Compute PPR-matrix"
		print "3. Save the Graph"
		print "4. Draw the Graph"
		print "5. Do clustering"
		print "6. Compute graph-affinities"
		print "7. Read label from a file"
		print "8. Read the positions of vertices"
		print "9. Read the maximum affinity for vertices"
		print "10. Write the adjacency and label"
		print "11. Calculate clustering coefficient"
		print "12: Do k-clustering"
		try:
			choice = int(raw_input('Enter your choice: '))
		except:
			print "Wrong option entered."
			break
		else:
			choice_dict = {0:exit, 1:list_props, 2:compute_ppr, 3:save_graph, 4:draw_graph, 5:find_communities, 6:compute_affinity, 7:read_label, 8:read_pos, 9:read_max_affinity, 10:write_graph, 11:clustering_coeff, 12:k_clustering}
			choice_dict.get(choice,0)(graph_object)
			if choice == 0:
				sys.exit(0)

if __name__ == '__main__':
	main()