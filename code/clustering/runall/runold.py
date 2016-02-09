#!/usr/bin/python
from sklearn import metrics
import os, time, random

results = open('old_results.txt','w')
# run combo clustering
def run_combo():
	tic = time.time()
	os.system("./../combo/comboCPP ../data/adj.net")
	toc = time.time()
	os.system("mv ../data/adj_comm_comboC++.txt ../data/combo.csv")
	results.write("combo: " + str(toc - tic) + '\n')

# run infomap clustering
def run_infomap(trials):
	seed = str(random.randint(0,10000))
	tic = time.time()
	os.system("./../infohiermap/infohiermap " + seed + " ../data/adj.net " + str(trials))
	toc = time.time()
	os.system("python ../../converters/pajek2csv.py ../data/adj.tree ../data/infomap.csv")
	os.system("rm ../data/adj.tree")
	results.write("infomap: " + str(toc - tic) + '\n')

run_combo()
run_infomap(10)
results.close()