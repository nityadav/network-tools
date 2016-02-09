#!/usr/bin/python
from sklearn import metrics
import os, time, random, sys

n = sys.argv[1].strip()
results = open('state_results.txt','w')
# run combo clustering
def run_combo():
	tic = time.time()
	os.system("./../combo/comboCPP adj.net")
	toc = time.time()
	os.system("mv adj_comm_comboC++.txt combo.csv")
	results.write("combo: " + str(toc - tic) + '\n')

# run infomap clustering
def run_infomap(trials):
	seed = str(random.randint(0,10000))
	tic = time.time()
	os.system("./../infohiermap/infohiermap " + seed + " adj.net " + str(trials))
	toc = time.time()
	os.system("python ../../converters/pajek2csv.py adj.tree infomap.csv")
	os.system("rm adj.tree adj_level*")
	results.write("infomap: " + str(toc - tic) + '\n')

def run_walktrap():
	os.system("./../walktrap02/convert_adj.py adj.csv adj.net")
	tic = time.time()
	os.system("./../walktrap02/walktrap adj.net -b -s -o walktrap.net")
	toc = time.time()
	os.system("./../walktrap02/convert_lbl.py " + n + " walktrap.net walktrap.csv")
	results.write("walktrap: " + str(toc - tic) + '\n')

run_combo()
#run_infomap(10)
#run_walktrap()
results.close()

os.system("mv combo.csv ./../eval/combo.csv")
#os.system("mv infomap.csv ./../eval/infomap.csv")
#os.system("mv walktrap.csv ./../eval/walktrap.csv")
os.system("mv lbl.csv ./../eval/lbl.csv")
print "*********** Time *********"
os.system("cat state_results.txt")
os.system("rm *.csv *.txt *.net")