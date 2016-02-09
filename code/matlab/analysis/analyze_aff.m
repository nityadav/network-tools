function stats = analyze_aff(adj,labels)
	n = size(adj,1);
	clusters = unique(labels);
	k = length(clusters);
	stats = [];
	for i = 1:k
		temp_lbl = ones([n,1])*2;
		mem = find(labels==clusters(i));
		p = length(mem);
		mem_deg = sum(adj(mem,mem),2);

		% find the seed set
		%seed = mem(randi(p));
		[max_deg, seed] = max(mem_deg);
		seed = mem(seed);
		seed_set = nbr_seed_selection(adj,seed);
		temp_lbl(seed_set) = 1;

		% count the percent of correctly found members
		missed = setdiff(mem,seed_set);
		extra = setdiff(seed_set,mem);
	
		%aff_mat = nnbr_affinity(adj,temp_lbl);
		aff_mat = unbr_affinity(adj,temp_lbl);
		%aff_mat = nmod_affinity(adj,temp_lbl);
		%aff_mat = umod_affinity(adj,temp_lbl);

		[max_val, max_lbl] = max(aff_mat,[],2);
		fp = find((temp_lbl - max_lbl) == -1);
		fn = find((temp_lbl - max_lbl) == 1);
		stats =  [stats; length(missed) length(extra) length(fp) length(fn)];
	end
	%{
	total_fp
	total_fn
	wrongs = total_fn + total_fp;
	accuracy = 1 - wrongs/(k*n);
	%}
	%stats_avg = mean(stats);
end

function seed_set = nbr_seed_selection(adj,seed)
	n = size(adj,1);
	% seed selection
	seed_set = [];
	% expansion from first neighbors
	nbrs1 = find(adj(seed,:));
	first_deg = sum(adj(nbrs1,nbrs1),2);
	[sort_val, sort_ind] = sort(first_deg);
	first_nbrs = nbrs1(find(first_deg > 1));
	% expansion from second neighbors
	freq_count = zeros([1,n]);
	for i = 1:length(first_nbrs)
		nbr = first_nbrs(i);
		nbrs2 = find(adj(nbr,:));
		freq_count(nbrs2) = freq_count(nbrs2) + 1;
	end
	sec_nbrs = find(freq_count > 3);
	seed_set = unique([seed first_nbrs sec_nbrs]);
end