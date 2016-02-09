% get hitting time matrix
% Brand 2005: A random walks perspective on maximizing satisfaction and profit
function mat = hitting_matrix(adj)
	num_nodes = size(adj,1);
	T = get_transition(adj);
	init_dist = ones([1,num_nodes])*(1/num_nodes);
	s = init_dist*(T^50);
	I = diag(ones([1,num_nodes]));
	o = ones([num_nodes,1]);
	A = pinv(I - T - o*s);
	mat = (o*diag(A)' - A)/diag(s);
end

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