function stability = max_stability(aff_mat)
	stability = sum(max(aff_mat,[],2));
end