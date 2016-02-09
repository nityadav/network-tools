#!/usr/bin/python
from sklearn import metrics
import os, time, random

# run combo clustering
def run_combo():
	tic = time.time()
	os.system("./../combo/comboCPP ../data/adj.net")
	toc = time.time()
	os.system("mv ../data/adj_comm_comboC++.txt ../data/combo.csv")
	# compare with ground truth
	clustering_labels = [int(line.strip()) for line in open('../data/combo.csv')]
	true_labels = [int(line.strip()) for line in open('../data/lbl.csv')]
	AMI = metrics.adjusted_mutual_info_score(true_labels, clustering_labels)
	ARI = metrics.adjusted_rand_score(true_labels, clustering_labels)
	return [toc - tic, AMI, ARI]

# run infomap clustering
def run_infomap(trials):
	seed = str(random.randint(0,10000))
	tic = time.time()
	os.system("./../infohiermap/infohiermap " + seed + " ../data/adj.net " + str(trials))
	toc = time.time()
	os.system("python ../../converters/pajek2csv.py ../data/adj.tree ../data/infomap.csv")
	os.system("rm ../data/adj.tree")
	# compare with ground truth
	clustering_labels = [int(line.strip()) for line in open('../data/infomap.csv')]
	true_labels = [int(line.strip()) for line in open('../data/lbl.csv')]
	AMI = metrics.adjusted_mutual_info_score(true_labels, clustering_labels)
	ARI = metrics.adjusted_rand_score(true_labels, clustering_labels)
	return [toc - tic, AMI, ARI]

results = open('results.csv','w')
results.write('combo,' + ','.join(run_combo()))
results.write('combo,' + ','.join(run_infomap(10)))