function perm_mat = perm_affinity(adj,labels)
    n = size(adj,1);
	deg = sum(adj,2);
	twicem = sum(deg);
	m = twicem/2;
	clusters = unique(labels);
	k = length(clusters);
	perm_mat = zeros([n,k]);
	for v = 1:n
		for i = 1:k
			c = clusters(i);
			labels_copy = labels;
			labels_copy(v) = c;
			mem = find(labels_copy==c);
			subadj = adj(mem,mem);
			new_v = find(mem==v);
			if sum(subadj(new_v,:)) == 0
				perm_mat(v,i) = 0;
				continue;
			end
			nbrs = find(adj(v,:));
			ext_nbrs = setdiff(nbrs, mem);
			if length(ext_nbrs) == 0
				perm_mat(v,i) = cluster_coeff(subadj,new_v);
				continue;
			end
			lbl_ext_nbrs = labels(ext_nbrs);
			[mode_lbl_ext_nbrs, mode_freq] = mode(lbl_ext_nbrs);
			perm_mat(v,i) = length(find(subadj(new_v,:)))/(deg(v)*mode_freq) + cluster_coeff(subadj,new_v) - 1;
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