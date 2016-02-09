import sys
import networkx as nx
import json
from networkx.readwrite import json_graph

if len(sys.argv) < 3:
	print "Usage: " + sys.argv[0] + " <graphml_file> <json_file>"
	sys.exit(1)

graphml_file = sys.argv[1].strip()
json_file = open(sys.argv[2].strip(), 'w')

G = nx.read_graphml(graphml_file)
node_link = json_graph.node_link_data(G)
json_data = json.dumps(node_link)
json_file.write(json_data)
json_file.close()