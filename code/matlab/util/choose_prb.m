function ind = choose_prb(prb_list)
	[sorted_prb, sorted_ind] = sort(prb_list);
	sorted_norm_prb = sorted_prb/sum(prb_list);
	ind = sorted_ind(find(rand<cumsum(sorted_norm_prb),1,'first'));
end