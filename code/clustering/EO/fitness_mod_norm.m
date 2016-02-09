% calculate the fitness of all the vertices
function fitness = fitness_mod_norm(adj,labels)
	n = size(adj,1);
	deg = sum(adj,2);
	twicem = sum(deg);
	clusters = unique(labels);
	k = length(clusters);
	fitness = zeros([n,1]);
	for i = 1:k
		c = clusters(i);
		mem = find(labels==c);
		subadj = adj(mem,mem);
		deg_c = sum(subadj,2);
		total_deg = sum(deg(mem));
		for v = 1:length(mem)
			deg_vc = sum(subadj(v,:));
			true_v = mem(v);
			fitness(true_v) = (deg_c(v)/deg(true_v)) - (total_deg/twicem);
		end
	end
end