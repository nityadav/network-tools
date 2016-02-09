#!/opt/local/bin/python2.7
from graph_tool.all import *
import sys

if len(sys.argv) < 2:
	print "usage: " + sys.argv[0] + " <adjfile>"
	sys.exit()

def getGraph(csvfile):
	linecount = 0
	edgemap = {}
	for line in csvfile:
		row = [item.strip() for item in line.strip().split(',')]
		row = filter(None,row)
		edgemap[linecount] = {}
		for col,weight in enumerate(row):
			weight = float(weight)
			if weight != 0:
				edgemap[linecount][col] = weight
		linecount += 1
	g = Graph(directed=False)
	g.add_vertex(linecount)
	wprp = g.new_edge_property("double")
	for source in edgemap.keys():
		weights = edgemap[source]
		for neighbor in weights.keys():
			g.add_edge(g.vertex(source), g.vertex(neighbor))
			wprp[g.edge(source,neighbor)] = weights[neighbor]
	return linecount,g,wprp

adjfile = open(sys.argv[1])
pprfile = open("ppr.csv",'w')
numv,graph,weights = getGraph(adjfile)
personal = graph.new_vertex_property("double")
for source in range(numv):
	print "Working for vertex no. " + str(source)
	personal[graph.vertex(source)] = 1.0
	if source != 0:
		personal[graph.vertex(source-1)] = 0.0
	ppr = pagerank(graph,pers=personal,weight=weights)
	pprlist = []
	for target in range(numv):
		pprlist.append(format(ppr[graph.vertex(target)], '.4f'))
		pprstr = ','.join(pprlist)
	pprfile.write(pprstr + '\n')


