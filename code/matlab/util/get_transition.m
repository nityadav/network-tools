% get transition matrix
function trans = get_transition(adj)
	num_nodes = size(adj,1);
	outdeg = diag(sum(adj,2));
	for i = 1:num_nodes
		if outdeg(i,i) == 0
			adj(i,i) = 1;
		end
	end
	outdeg = diag(sum(adj,2));
	trans = (outdeg^-1)*adj;
end