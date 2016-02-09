% get_laplacian gives the normalized laplacian matrix for an adjacency matrix
function ret=get_laplacian(adj)
	deg = diag(sum(adj,2));
	lpcn = deg - adj;
	ret = (deg^(-1/2))*lpcn*(deg^(-1/2));
end
