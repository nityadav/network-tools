% calculate the access time affinity
function affinity = access_affinity(adj,k,labels,s)
	num_nodes = size(adj,1);
	inv_affinity = zeros([1,k]);
	% make s singleton cluster by assigning a unique label
	labels(s) = -1;
	reach_first_prob = reach_first(adj,k+1,labels,s);
	% find all those vertices which have non-zero probability
	reachable = find(reach_first_prob);
	for i = 1:length(reachable)
		t = reachable(i);
		c = labels(t);
		mem = find(labels==c);
		mem = mem(mem~=t);
		% modify the graph to calculate first hitting distance
		adj_copy = adj;
		adj_copy(:,mem) = [];
		adj_copy(mem,:) = [];
		new_s = s - sum(mem < s);
		new_t = t - sum(mem < t);
		% there can be a disconnected component
		first_hit_dist = hitting_distance(adj_copy,new_s,new_t);
		inv_affinity(c) = inv_affinity(c) + (reach_first_prob(t)*first_hit_dist);
	end
	affinity = 1./inv_affinity;
	affinity = affinity./sum(affinity);
end