function stability = lbl_stability(aff_mat, labels)
	clusters = unique(labels);
	n = size(aff_mat,1);
	stability = 0;
	for i = 1:n
		stability = stability + aff_mat(i,find(clusters==labels(i)));
	end
end