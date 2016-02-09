function clustering = nbh_clustering(adj,identity)
	n = size(adj,1);
	clustering = zeros([n,1]);
	set = 1:n;
	while ~isempty(set)
		src = set(1);
		connected_comp = get_connected_nodes(adj,src);
		set = setdiff(set,connected_comp);
		% work with only the connected component
		new_identity = identity(connected_comp);
		subadj = adj(connected_comp,connected_comp);
		subn = size(subadj,1);
		% construct the similarity matrix
		sim_mat = zeros([subn,subn]);
		subdeg = sum(subadj,2);
		for i = 1:subn
			for j = i+1:subn
				num_commons = length(intersect(find(subadj(i,:)),find(subadj(j,:))));
				sim_mat(i,j) = subadj(i,j) + num_commons/(subdeg(i) + subdeg(j));
				sim_mat(j,i) = sim_mat(i,j);
			end
		end
		% peel and recurse
		labels = ones([subn,1])*2;
		% find the highest degree node
		[max_deg, seed] = max(subdeg);
		nbrs = find(subadj(seed,:));
		labels(seed) = 1;
		labels(nbrs) = 1;
		% first remove
		tbr = [1];
		rcount = 0;
		while ~isempty(tbr)
			aff = get_affinity_matrix(sim_mat,labels);
			[max_aff, max_aff_id] = max(aff,[],2);
			tbr = find((labels - max_aff_id) == -1);
			labels(tbr) = 2;
			rcount = rcount + length(tbr);
		end
		rcount
		% second add
		tba = [1];
		acount = 0;
		while ~isempty(tba)
			aff = get_affinity_matrix(sim_mat,labels);
			[max_aff, max_aff_id] = max(aff,[],2);
			tba = find((labels - max_aff_id) == 1);
			labels(tba) = 1;
			acount = acount + length(tba);
		end
		acount
		% peel the community out
		peeled = find(labels==1);
		peeled_identity = new_identity(peeled);
		peeled_lbl = min(peeled_identity);
		unpeeled = find(labels==2);
		unpeeled_identity = new_identity(unpeeled);
		unpeeled_clustering = nbh_clustering(subadj(unpeeled,unpeeled), unpeeled_identity);
		connected_comp_clustering = ones([length(connected_comp),1])*peeled_lbl;
		connected_comp_clustering(unpeeled) = unpeeled_clustering;
		clustering(connected_comp) = connected_comp_clustering;
	end
end

% get affinity matrix from similarity matrix and given labels
function aff_mat = get_affinity_matrix(sim_mat, labels)
	% construct membership matrix
	n = size(sim_mat,1);
	clusters = unique(labels);
	k = length(clusters);
	mem_mat = zeros([n,k]);
	for i = 1:n
		mem_mat(i,find(clusters == labels(i))) = 1;
	end
	% construct affinity matrix
	aff_mat = sim_mat*mem_mat;
	%{
	for i = 1:k
		aff_mat(:,i) = aff_mat(:,i)./sum(mem_mat(:,i));
	end
	%}
end

% find all the vertices that can be reached from a vertex s
function nodes = get_connected_nodes(adj,s)
	num_nodes = size(adj,1);
	visited = zeros([1,num_nodes]);
	queue = [s];
	while length(queue) > 0
		curr = queue(1);
		queue(1) = [];
		visited(curr) = 1; 
		neighbors = find(adj(curr,:));
		unvisited = neighbors(find(visited(neighbors)==0));
		queue = [queue unvisited];
	end
	nodes = find(visited);
end