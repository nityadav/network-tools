function deg = get_comm_degree(adj,labels)
	n = size(adj,1);
	clusters = unique(labels);
	k = length(clusters);
	deg = zeros([n,1]);
	for i = 1:k
		c = clusters(i);
		mem = find(labels==c);
		subadj = adj(mem,mem);
		deg(mem) = sum(subadj,2);
		% normalize within community
		max_deg = max(deg(mem));
		min_deg = min(deg(mem));
		for j = 1:length(mem)
			deg(mem(j)) = (deg(mem(j)) - min_deg)*10/(max_deg - min_deg) + 2;
		end
	end
end