% calculate the probability with which a random walker will reach a 
% vertex in the cluster first among all the vertices in that cluster
function prob = reach_first(adj,k,labels,src)
	num_nodes = size(adj,1);
	prob = zeros([1,num_nodes]);
	labels(src) = -1;
	for cluster = 1:k
		members = find(labels==cluster);
		% make all the edges directed inwards for all the members of the cluster
		adj_copy = adj;
		adj_copy(members,:) = 0;
		% do the random walks now
		prob_dist = random_walk(adj_copy,src,30);
		prob_clust = prob_dist(members);
		% normalize
		prob_clust = prob_clust./sum(prob_clust);
		prob(members) = prob_clust;
	end
end