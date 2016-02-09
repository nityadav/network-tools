% calculate cluster hitting distance affinity
function affinity = commute_affinity(adj,k,labels,s)
	num_nodes = size(adj,1);
	inv_affinity = zeros([1,k]);
	% make s singleton cluster by assigning a unique label
	reach_first_prob = reach_first(adj,k,labels,s);
	% find all those vertices which have non-zero probability
	reachable = find(reach_first_prob);
	for i = 1:length(reachable)
		t = reachable(i);
		c = labels(t);
		mem = find(labels==c);
		mem = mem(mem~=s);
		mem = mem(mem~=t);
		% modify the graph to calculate first hitting distance
		adj_copy = adj;
		adj_copy(:,mem) = [];
		adj_copy(mem,:) = [];
		new_s = s - sum(mem < s);
		new_t = t - sum(mem < t);
		% remove disconnected vertices
		new_num_nodes = size(adj_copy,1);
		connected = sort(get_connected_nodes(adj_copy, new_s));
		adj_copy = adj_copy(connected,connected);
		disconnected = setdiff(1:new_num_nodes,connected);
		new_s = new_s - sum(disconnected < new_s);
		new_t = new_t - sum(disconnected < new_t);
		% calculate hitting distances
		first_hit_dist = hitting_distance(adj_copy,new_s,new_t);
		ret_hit_dist = hitting_distance(adj,t,s);
		inv_affinity(c) = inv_affinity(c) + (reach_first_prob(t)*(first_hit_dist + ret_hit_dist));
	end
	inv_affinity
	affinity = 1./inv_affinity;
	affinity = affinity./sum(affinity);
end