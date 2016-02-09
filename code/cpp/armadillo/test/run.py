import os, time
from sklearn import metrics

def run_peeling(prog, graph):
	# record time of execution
	tic = time.time()
	os.system("./" + prog + " data/" + graph + "/adj.net")
	toc = time.time()
	# get the accuracy
	clus_file = open('peel.csv')
	clus_labels = [int(line.strip()) for line in clus_file]
	truth_file = open("data/" + graph + "/lbl.csv")
	true_labels = [int(line.strip()) for line in truth_file]
	AMI = metrics.adjusted_mutual_info_score(true_labels, clus_labels)
	ARI = metrics.adjusted_rand_score(true_labels, clus_labels)
	return ["{:.4f}".format(toc - tic), "{:.4f}".format(AMI), "{:.4f}".format(ARI)]

subdirs = os.listdir('./data/')
#subdirs.remove('.DS_Store')
timef = open('timings.txt','w')
accf = open('accuracy.txt','w')
progs = ['peel_det_fast']#,'peel_det','peel_prb_fast','peel_prb']

for graph in subdirs:
	timef.write(graph)
	accf.write(graph)
	for prog in progs:
		print "Working on: " + prog + " and data: " + graph
		vals = run_peeling(prog,graph)
		timef.write(" & " + vals[0])
		accf.write(" & " + vals[1] + "," + vals[2])
	timef.write('\n')
	accf.write('\n')
		
timef.close()
accf.close()