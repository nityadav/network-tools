function aff_mat = modularity_affinity(adj,labels)
	n = size(adj,1);
	deg = sum(adj,2);
	twicem = sum(deg);
	m = twicem/2;
	clusters = unique(labels);
	k = length(clusters);
	aff_mat = zeros([n,k]);
	for v = 1:n
		for i = 1:k
			c = clusters(i);
			labels_copy = labels;
			labels_copy(v) = c;
			mem = find(labels_copy==c);
			subadj = adj(mem,mem);
			new_v = find(mem==v);
			deg_vc = sum(subadj(new_v,:));
			deg_c = sum(deg(mem));
			aff_mat(v,i) = deg_vc - deg(v)*deg_c/twicem;
		end
	end
end