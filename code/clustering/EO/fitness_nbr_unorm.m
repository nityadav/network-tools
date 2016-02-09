function fitness = fitness_nbr_unorm(sim_mat,labels)
	n = size(sim_mat,1);
	clusters = unique(labels);
	k = length(clusters);
	mem_mat = zeros([n,k]);
	for i = 1:k
		mem = find(labels==clusters(i));
		mem_mat(mem,i) = 1;
	end
	aff_mat = sim_mat*mem_mat;
	fitness = aff_mat(:,labels);
end