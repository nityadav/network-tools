function fitness = fitness_conv(sim_mat, labels)
	n = length(labels);
	fitness = zeros([n,1]);
	clusters = unique(labels);
	k = length(clusters);
	for i = 1:k
		c = clusters(i);
		mem = find(labels==c);
		for j = 1:length(mem)
			fitness(mem(j)) = sum(sim_mat(mem,mem(j)));
		end
	end
end