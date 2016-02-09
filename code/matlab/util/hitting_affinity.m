function affinity = hitting_affinity(adj,k,labels)
	num_nodes = size(adj,1);
    vol = sum(sum(adj,2));
    vol_mat = ones([num_nodes,k])*vol;
	inv_affinity = zeros([num_nodes,k]);
	I = diag(ones([1,num_nodes]));
	T = get_transition(adj);
	G = I - T;
	for cluster = 1:k
		% find affintiy for the members
		members = find(labels==cluster);
		for i = 1:length(members)
			mem = members(i);
			labels_copy = labels;
			labels_copy(mem) = -1;
			non_members = find(labels_copy~=cluster);
			G_copy = G(non_members,non_members);
			C = ones([length(non_members),1]);
			inv_affinity(non_members, cluster) = (G_copy^-1)*C;
		end
		% find the affinity for non-members
		non_members = find(labels~=cluster);
		G_copy = G(non_members,non_members);
		C = ones([length(non_members),1]);
		inv_affinity(non_members, cluster) = (G_copy^-1)*C;
    end
    inv_affinity = vol_mat - inv_affinity
	affinity = 1./inv_affinity;
	for i = 1:num_nodes
		affinity(i,:) = affinity(i,:)./sum(affinity(i,:));
	end
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