function fitness = perm_fitness(adj,labels)
	n = size(adj,1);
	deg = sum(adj,2);
	twicem = sum(deg);
	m = twicem/2;
	clusters = unique(labels);
	k = length(clusters);
	fitness = zeros([n,1]);
	for i = 1:k
		c = clusters(i);
		mem = find(labels==c);
		subadj = adj(mem,mem);
		for v = 1:length(mem)
			if sum(subadj(v,:)) == 0
				fitness(mem(v)) = 0;
				continue;
			end
			nbrs = find(adj(mem(v),:));
			ext_nbrs = setdiff(nbrs,mem);
			if length(ext_nbrs) == 0
				fitness(mem(v)) = cluster_coeff(subadj,v);
				continue;
			end
			lbl_ext_nbrs = labels(ext_nbrs);
			[mode_lbl_ext_nbrs, mode_freq] = mode(lbl_ext_nbrs);
			fitness(mem(v)) = length(find(subadj(v,:)))/(deg(mem(v))*mode_freq) + cluster_coeff(subadj,v) - 1;
		end
	end
end

function coeff = cluster_coeff(adj,v)
	nbrs = find(adj(v,:));
	if length(nbrs) == 1
		coeff = 1;
	else
		coeff = sum(sum(adj(nbrs,nbrs)))/(2*nchoosek(length(nbrs),2));
	end
end