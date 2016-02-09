% gives a vector of hitting distance from 's' vertex to 't' vertex
function hd = hitting_distance(adj,s,t)
	num_nodes = size(adj,1);
	deg = sum(adj,2);
	if ~all(deg)
		error('The Graph needs to be connected.');
	end
	if ~all(all(adj == adj'))
		error('The Graph needs to be un-directed.');
	end
	vol = sum(sum(adj));
	L = get_laplacian(adj);
	[V,E] = eig(L);
	sigma = 0;
	for k = 2:num_nodes
		sigma = sigma + ((V(t,k)^2/deg(t)) - (V(t,k)*V(s,k)/sqrt(deg(t)*deg(s))))/E(k,k);
	end
	vol = sum(sum(adj));
	hd = vol*sigma;
end