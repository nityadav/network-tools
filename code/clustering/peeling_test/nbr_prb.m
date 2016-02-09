function clustering = nbr_prb(adj,weight,limit)
	tic
	% hyper-parameters begin
	%weight = 5; 
	%limit = 4;
	% pre-calculations
	m = size(adj,1);
	clustering = zeros([m,1]);
	sim_mat = get_nbr_sim(adj,weight);
	deg = sum(adj,2);
	% iteration begins
	residual = 1:m;
	k = 1;
	while ~isempty(residual)
		n = length(residual);
		A = adj(residual,residual);
		D = deg(residual);
		[sorted_deg, sorted_ind] = sort(D);
		sorted_norm_deg = sorted_deg/sum(D);
		S = sim_mat(residual,residual);
		% begin iteration for peeling
		found = 0;
		for p = 1:n
			% form the seed community
			seed = sorted_ind(find(rand<cumsum(sorted_norm_deg),1,'first'));
			seed_set = nbr_seed_selection(A,seed,limit,n);
			labels = ones([n,1])*2;
			labels(seed_set) = 1;
			% reorganize
			labels = reorganize(S,labels,n);
			% peel the community out
			peeled = residual(find(labels==1));
			unpeeled = residual(find(labels==2));
			num_peeled = length(peeled);
			num_unpeeled = length(unpeeled);
			if (num_peeled ~= 0) && (num_unpeeled ~= 0)
				found = 1;
				break;
			end
		end
		if ~found
			% if not found then the residual must be the last cluster
			clustering(residual) = k;
			break;
		else
			% mark the peeled cluster and define the residual
			if num_unpeeled > num_peeled
				residual = unpeeled;
				marked = peeled;
			else
				residual = peeled;
				marked = unpeeled;
			end
			clustering(marked) = k;
		end
		k = k + 1;
	end
	toc
end

function final_labels = reorganize(sim_mat, labels, n)
	% remove from community
	tbr = [1];
	while ~isempty(tbr)
		aff = nbr_affinity(sim_mat,labels,n);
		[max_aff, max_aff_id] = max(aff,[],2);
		tbr = find((labels - max_aff_id) == -1);
		labels(tbr) = 2;
	end
	% add to community
	tba = [1];
	while ~isempty(tba)
		aff = nbr_affinity(sim_mat,labels,n);
		[max_aff, max_aff_id] = max(aff,[],2);
		tba = find((labels - max_aff_id) == 1);
		labels(tba) = 1;
	end
	final_labels = labels;
end

function seed_set = nbr_seed_selection(adj,seed,limit,n)
	seed_set = [seed];
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
	seed_set = [seed first_nbrs sec_nbrs];
end

function aff_mat = nbr_affinity(sim_mat,labels,n)
	mem_mat = zeros([n,2]);
	for i = 1:2
		mem = find(labels == i);
		mem_mat(mem,i) = 1/length(mem);
	end
	aff_mat = sim_mat*mem_mat;
end

function sim_mat = get_nbr_sim(adj,weight)
	n = size(adj,1);
	adj2 = adj*adj;
	deg = sum(adj,2);
	deg_mat = repmat(deg,1,n) + repmat(deg',n,1);
	sim_mat = adj2./deg_mat + weight*adj;
end