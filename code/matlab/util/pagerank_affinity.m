function affinity = pagerank_affinity(adj,k,labels,s)
	affinity = zeros([1,k]);
	for cluster = 1:k
		labels(s) = cluster;
		members = find(labels==cluster);
		subadj = adj(members,members);
		new_s = find(members==s);
		ranks = pagerank(subadj)
		affinity(cluster) = ranks(new_s);
	end
	affinity = affinity./sum(affinity);
end