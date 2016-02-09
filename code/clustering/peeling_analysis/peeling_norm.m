function [Jtable, progress] = peeling_norm(adj,truth,trials)
	n = size(adj,1);
	%weights = [0 0.5 1 2 3 4 5];
	weights = [5];
	%limits = [1 2 3 4 5 6];
	limits = [4];
	Jtable = zeros([length(weights)+1,length(limits)+1]);
	Ttable = zeros([length(weights)+1,length(limits)+1]);
	for t = 1:trials
		temp1 = zeros([length(weights)+1,length(limits)+1]);
		temp1(1,2:end) = limits;
		temp1(2:end,1) = weights;
		temp2 = zeros([length(weights)+1,length(limits)+1]);
		temp2(1,2:end) = limits;
		temp2(2:end,1) = weights;
		for i = 1:length(weights)
			w = weights(i);
			for j = 1:length(limits)
				l = limits(j);
				tic;
				sim_mat = get_nbr_sim(adj,w);
				global progress
				progress = [];
				labels = recursive_nbr(adj,n,1:n,sim_mat,l);
				temp2(i+1,j+1) = toc;
				temp1(i+1,j+1) = jaccard_index(labels,truth);
			end
		end
		Jtable = Jtable + temp1;
		Ttable = Ttable + temp2;
	end
	Jtable = Jtable/trials;
	Ttable = Ttable/trials;
end

function clustering = recursive_nbr(adj, m, identity, sim_mat, limit)
	clustering = zeros([m,1]);
	n = size(adj,1);
	% peel and recurse
	deg = sum(adj,2);
	[sorted_deg, sorted_ind] = sort(deg);
	sorted_norm_deg = sorted_deg/sum(deg);
	found = 0;
	for p = 1:n
		seed = sorted_ind(find(rand<cumsum(sorted_norm_deg),1,'first'));
		labels = ones([n,1])*2;
		% form the seed community
		seed_set = nbr_seed_selection(adj,seed,limit);
		labels(seed_set) = 1;
		% add to community
		tba = [1];
		while ~isempty(tba)
			aff = nbr_affinity(sim_mat,labels);
			[max_aff, max_aff_id] = max(aff,[],2);
			tba = find((labels - max_aff_id) == 1);
			labels(tba) = 1;
		end
		% remove from community
		tbr = [1];
		while ~isempty(tbr)
			aff = nbr_affinity(sim_mat,labels);
			[max_aff, max_aff_id] = max(aff,[],2);
			tbr = find((labels - max_aff_id) == -1);
			labels(tbr) = 2;
		end
		% peel the community out
		peeled = find(labels==1);
		unpeeled = find(labels==2);
		num_peeled = length(peeled);
		num_unpeeled = length(unpeeled);
		if (num_peeled ~= 0) && (num_unpeeled ~= 0)
			found = 1;
			break;
		end
	end
	% add to progress
	prog_row = zeros([1,m]);
	prog_row(identity(seed_set)) = 1;
	global progress
	progress = [progress; prog_row];
	if found
		% add to progress
		prog_row = zeros([1,m]);
		prog_row(identity(peeled)) = 1;
		global progress
		progress = [progress; prog_row];
		% make residual as the maximum left
		residual = unpeeled;
		marked = peeled;
		% make the recursive call
		residual_identity = identity(residual);
		marked_identity = identity(marked);
		prog_row = zeros([1,m]);
		prog_row(marked_identity) = 1;
		global progress
		progress = [progress; prog_row];
		residual_clustering = recursive_nbr(adj(residual,residual), m, residual_identity, sim_mat(residual,residual), limit);
		clustering(marked_identity) = min(marked_identity);
		clustering(residual_identity) = residual_clustering(residual_identity);
	else
		clustering(identity) = min(identity);
	end
end

function seed_set = nbr_seed_selection(adj,seed,limit)
	n = size(adj,1);
	% seed selection
	seed_set = [];
	% expansion from first neighbors
	first_nbrs = find(adj(seed,:));
	% expansion from second neighbors
	freq_count = zeros([1,n]);
	for i = 1:length(first_nbrs)
		nbr = first_nbrs(i);
		nbrs2 = find(adj(nbr,:));
		freq_count(nbrs2) = freq_count(nbrs2) + 1;
	end
	sec_nbrs = find(freq_count >= limit);
	seed_set = unique([seed first_nbrs sec_nbrs]);
end

function aff_mat = nbr_affinity(sim_mat,labels)
	n = size(sim_mat,1);
	clusters = unique(labels);
	k = length(clusters);
	mem_mat = zeros([n,k]);
	for i = 1:k
		mem = find(labels==clusters(i));
		multiplier = length(mem);
		mem_mat(mem,i) = 1/multiplier;
	end
	s = size(sim_mat);
	m = size(mem_mat);
	aff_mat = sim_mat*mem_mat;
end

function sim_mat = get_nbr_sim(adj,weight)
	n = size(adj,1);
	adj2 = adj*adj;
	deg = sum(adj,2);
	deg_mat = repmat(deg,1,n) + repmat(deg',n,1);
	sim_mat = adj2./deg_mat + weight*adj;
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

function JI = jaccard_index(label,truth)
    n = length(label);
    N = zeros(2,2);
    for i = 1:n
        for j = i+1:n
            N((label(i)==label(j))+1,(truth(i)==truth(j))+1) = N((label(i)==label(j))+1,(truth(i)==truth(j))+1) + 1;
        end
    end
    JI = N(2,2)/(N(1,2) + N(2,1) + N(2,2));
end

function stability = nbr_stability(sim_mat, labels)
	clusters = unique(labels);
	k = length(clusters);
	stability = 0;
	for i = 1:k
		mem = find(labels==clusters(i));
		stability = stability + sum(sum(sim_mat(mem,mem)));
	end
end