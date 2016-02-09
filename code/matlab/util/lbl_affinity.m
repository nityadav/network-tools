function aff_vec = lbl_affinity(aff_mat, labels)
	clusters = unique(labels);
	n = size(aff_mat,1);
	aff_vec = zeros([n,1]);
	for i = 1:n
		aff_vec(i) = aff_mat(i,find(clusters==labels(i)));
	end
end