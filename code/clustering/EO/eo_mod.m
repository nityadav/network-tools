function [clustering,maxQ,besttrial,worst_time] = eo_mod(adj,trials)
	% set alpha = 1, for enough number of evolutionary steps to happen
	n = size(adj,1);
	maxQ = -1/2;
	worst_time = 0;
	alpha = 1;
	for i = 1:trials
		tic;
		labels = recursive_eo(adj,alpha,0,1:size(adj,1));
		time = toc;
		if time > worst_time
			worst_time = time;
		end
		Q = modularity(adj,labels);
		if Q > maxQ
			clustering = labels;
			maxQ = Q;
			besttrial = i;
		end
	end
end

function lbl = recursive_eo(adj, alpha, prev_maxQ, true_index)
	n = size(adj,1);
	lbl = zeros([n,1]);
	deg = sum(adj,2);
	% create initial random partition
	partition = ones([n,1]);
	partition(randsample(n,round(n/2))) = 2;
	maxQ = 0;
	best_labels = lbl;
	% start the evolutionary process (self-organizing steps)
	for step = 1:n*alpha
		labels = get_communities_from_partition(adj, partition);
		Q = modularity(adj,labels);
		% check if this is the best partition so far
		if Q > maxQ
			maxQ = Q;
			best_partition = partition;
			best_labels = labels;
		end
		% choose the fitness function
		fitness = fitness_mod(adj,labels);
		% do the evolution by moving the least fit to other partition
		[sort_val, sort_ind] = sort(fitness);
		chosen = sort_ind(rank_selection(n));
		partition(chosen) = ~(partition(chosen) - 1) + 1;
	end
	% go for the division only if maxQ is more than prev_maxQ
	if maxQ > prev_maxQ
		p1 = find(best_partition==1);
		p2 = find(best_partition==2);
		labels1 = recursive_eo(adj(p1,p1), alpha, maxQ, true_index(p1));
		labels2 = recursive_eo(adj(p2,p2), alpha, maxQ, true_index(p2));
		% merge the labels
		lbl(p1) = labels1;
		lbl(p2) = labels2;
	% return the labels using true_index so as to not cause conflicts in the labels
	else
		k = length(unique(best_labels));
		for i = 1:k
			mem = find(best_labels==i);
			true_label = min(true_index(mem));
			lbl(mem) = true_label;
		end
	end
end

function labels = get_communities_from_partition(adj, partition)
	n = size(adj,1);
	labels = zeros([n,1]);
	% find the connected components in first partition
	mem = find(partition==1);
	subadj = adj(mem,mem);
	pset = 1:length(mem);
	iter = 1;
	while ~isempty(pset)
		cc = get_connected_nodes(subadj,pset(1));
		pset = setdiff(pset,cc);
		labels(mem(cc)) = iter;
		iter = iter + 1;
	end
	% find the connected components in second partition
	mem = find(partition==2);
	subadj = adj(mem,mem);
	pset = 1:length(mem);
	while ~isempty(pset)
		cc = get_connected_nodes(subadj,pset(1));
		pset = setdiff(pset,cc);
		labels(mem(cc)) = iter;
		iter = iter + 1;
	end
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

function selection = rank_selection(n)
	tau = 1 + 1/log(n);
	prob = zeros([1,n]);
	for i = 1:n
		prob(i) = i^(-tau);
	end
	prob = prob./sum(prob);
	p = cumsum([0; prob(1:end-1).'; 1+1e3*eps]);
	[a a] = histc(rand,p);
	selection = find(histc(rand,p));
end

function Q = modularity(adj,labels)
    n = size(adj,1);
    deg = sum(adj,2);
    twicem = sum(deg);
    clusters = unique(labels);
    k = length(clusters);
    Q = 0;
    for i = 1:k
        c = clusters(i);
        mem = find(labels==c);
        subadj = adj(mem,mem);
        deg_c = sum(subadj,2);
        total_deg = sum(deg(mem));
        for v = 1:length(mem)
            deg_vc = sum(subadj(v,:));
            true_v = mem(v);
            Q = Q + deg_c(v) - (deg(true_v)*total_deg/twicem);
        end
    end
    Q = Q/twicem;
end