% get_degree_matrix gives the degree matrix for an adjacency matrix
function ret=get_degree(adj)
	ret = diag(sum(adj,2));
end
