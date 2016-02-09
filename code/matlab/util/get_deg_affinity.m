function deg_aff = get_deg_affinity(adj,labels)
	n = size(adj,1);
	deg = sum(adj,2);
	clusters = unique(labels);
	k = length(clusters);
	comdeg = zeros([n,1]);
	for i = 1:k
		c = clusters(i);
		mem = find(labels==c);
		subadj = adj(mem,mem);
		comdeg(mem) = sum(subadj,2);
	end
	deg_aff = comdeg./deg;
	% normalize
	min_val = min(deg_aff);
	max_val = max(deg_aff);
	for i = 1:n
		deg_aff(i) = (deg_aff(i) - min_val)*15/(max_val - min_val);
	end
end