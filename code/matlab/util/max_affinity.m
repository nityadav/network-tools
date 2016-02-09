function aff_vec = max_affinity(aff_mat)
	n = size(aff_mat,1);
	aff_vec = max(aff_mat,[],2);
	% normalize
	max_item = max(aff_vec);
	min_item = min(aff_vec);
	for i = 1:length(aff_vec)
		aff_vec(i) = (aff_vec(i) - min_item)*10/(max_item - min_item);
	end
end