% get_degree_matrix gives the degree matrix for an adjacency matrix
function ret=get_degree(adj)
	n = size(adj,1);
	ret(n,n) = 0;
	for i = 1:n
		ret(i,i) = sum(adj(i,1:n));
	endfor
endfunction
