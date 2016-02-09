function perm = permanence(adj,labels)
    clusters = unique(labels);
    k = length(clusters);
	perm_mat = perm_affinity(adj,labels);
	n = size(adj,1);
	perm = 0;
	for i = 1:n
		perm = perm + perm_mat(i,find(clusters==labels(i)));
	end
	perm = k*perm/n;
end