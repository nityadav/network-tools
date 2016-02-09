% function to give pagerank vector
function pagerank = pagerank(adj)
	teleport = 0.15;
  	walklen = 30;
	num_nodes = size(adj,1);
	% form the transition matrix

	% 
	trans = get_transition(adj);
	trans = trans*(1-teleport);
	teleport_mat = ones(num_nodes)*(teleport/num_nodes);
	final_trans = trans + teleport_mat;
	pdist = ones([1,num_nodes]);
	pagerank = pdist*(final_trans^walklen);
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