function aff_mat = nbr_affinity(adj,labels,wt)
	n = size(adj,1);
	clusters = unique(labels);
	k = length(clusters);
	mem_mat = zeros([n,k]);
	for i = 1:k
		mem = find(labels==clusters(i));
		multiplier = 1/length(mem);
		mem_mat(mem,i) = multiplier;
	end
	sim_mat = get_nbr_sim(adj,wt);
	aff_mat = sim_mat*mem_mat;
end

function sim_mat = get_nbr_sim(adj,wt)
	adj2 = adj*adj;
	deg = sum(adj,2);
	n = size(adj,1);
	sim_mat = zeros([n,n]);
	for i = 1:n
		for j = i+1:n
			sim_mat(i,j) = adj(i,j)*wt + adj2(i,j)/(deg(i) + deg(j));
			sim_mat(j,i) = sim_mat(i,j);
		end
	end
end