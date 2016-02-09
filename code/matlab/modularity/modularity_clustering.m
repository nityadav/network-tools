function labels = modularity_clustering(adj,k)
	num_verts = size(adj,1);
	labels = k*ones([num_verts,1]);
	id_mapping = 1:num_verts;
	adj_copy = adj;
	for iter = 1:k-1
		n = size(adj,1);
		deg = sum(adj,2);
		temp_labels = ones([n,1]);
		% construct initial cluster
		[max_deg, max_deg_id] = max(deg);
		nbrs = find(adj(max_deg_id,:));
		temp_labels(nbrs) = 2;
		stopper = 0;
		while true
			aff = modularity_affinity(adj,temp_labels);
			[max_aff, max_aff_id] = max(aff,[],2);
			disagree = find((max_aff_id == temp_labels)==0);
			if length(disagree) == 0
				break;
			end
			% invert the temp_labels for all nodes that disagree
			for i = 1:length(disagree)
				temp_labels(disagree(i)) = ~(temp_labels(disagree(i))-1) + 1;
			end
			stopper = stopper + 1;
			if stopper == 3
				break;
			end
		end
		labels(id_mapping(find(temp_labels==2))) = iter;
		id_mapping = find(labels==k);
		adj = adj_copy(id_mapping,id_mapping);
	end
end