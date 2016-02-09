#!/opt/local/bin/python2.7
from graph_tool.all import *
import sys

if len(sys.argv) < 2:
	print "Usage: " + sys.argv[0] + " <csv_file> <label_file> <name_file>"
	sys.exit(1)

def get_graph(csvfile):
	linecount = 0
	edgemap = {}
	for line in csvfile:
		row = [item.strip() for item in line.strip().split(',')]
		row = filter(None,row)
		edgemap[linecount] = {}
		for col,weight in enumerate(row):
			weight = int(weight)
			if weight != 0:
				edgemap[linecount][col] = weight
		linecount += 1
	graph = Graph(directed=False)
	graph.add_vertex(linecount)
	# create an edge property
	weight_prop = graph.new_edge_property("int")
	for source in edgemap.keys():
		weights = edgemap[source]
		for neighbor in weights.keys():
			graph.add_edge(graph.vertex(source), graph.vertex(neighbor))
			weight_prop[graph.edge(source,neighbor)] = weights[neighbor]
	# make the edge property internal to graph
	graph.edge_properties["weight"] = weight_prop
	return graph

def add_vertex_property(graph, prop_list, prop_name, prop_type):
	if graph.num_vertices() != len(prop_list):
		print "There should be a property for each vertex in the graph."
		return
	# convert the list into dict
	prop_dict = graph.new_vertex_property(prop_type)
	for v in range(graph.num_vertices()):
		prop_dict[graph.vertex(v)] = prop_list[v]
	graph.vertex_properties[prop_name] = prop_dict

# construct the graph
G = get_graph(open(sys.argv[1]))

# add vertex labels
if len(sys.argv) == 3:
	label_map = {'Algorithms & Theory':0, 'Artificial Intelligence':1, 'Databases':2,'Hardware & Architecture':3, 'Machine Learning & Pattern Recognition':4, 'Networks & Communications':5}
	labels_list = [int(line.strip()) for line in open(sys.argv[2])]
	add_vertex_property(G, labels_list, 'label', 'int')

# add vertex names
if len(sys.argv) == 4:
	names_list = [line.strip() for line in open(sys.argv[3])]
	add_vertex_property(G, names_list, 'name', 'string')

# show the properties
print "Graph has been created with following properties:"
G.list_properties()

# save the graph in graphml format
G.save('graph.graphml', fmt='graphml')

""" draw the graph using ARF layout
label_prop = G.vertex_properties['label']
vertex_pos = arf_layout(G, max_iter=0)
graph_draw(G, pos=vertex_pos, vertex_fill_color=label_prop, output="coauthor.png")
"""

""" draw the graph using SFDP layout
vertex_pos = sfdp_layout(G)
label_prop = G.vertex_properties['label']
graph_draw(G, pos=vertex_pos, vertex_fill_color=label_prop, output="coauthor.png")
"""

""" perform clustering and draw the graph
state = minimize_blockmodel_dl(G)
b = state.b
vertex_pos = arf_layout(G, max_iter=0)
graph_draw(G, pos=vertex_pos, vertex_fill_color=b, output="coauthor.png")
"""

