function fitness = fitness_nbr(sim_mat,labels)
	n = size(sim_mat,1);
	clusters = unique(labels);
	k = length(clusters);
	mem_mat = zeros([n,k]);
	for i = 1:k
		mem = find(labels==clusters(i));
		multiplier = 1/length(mem);
		mem_mat(mem,i) = multiplier;
	end
	aff_mat = sim_mat*mem_mat;
	fitness = aff_mat(:,labels);
end