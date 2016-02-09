from sklearn import metrics
import sys

if len(sys.argv) != 3:
	print "usage: " + sys.argv[0] + "<ground_truth> + <clustering_result>"

true_labels = [int(line.strip()) for line in open(sys.argv[1])]
clus_labels = [int(line.strip()) for line in open(sys.argv[2])]

AMI = metrics.adjusted_mutual_info_score(true_labels, clus_labels)
ARI = metrics.adjusted_rand_score(true_labels, clus_labels)
print "Adjusted Mutual Information: " + str(AMI)
print "Adjusted Rand Index: " + str(ARI)