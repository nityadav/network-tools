function scoring_test(adj,truth,lbl_mat)
	num_lbls = size(lbl_mat,2);
	ari_scores = zeros([1,num_lbls]);
	perm_scores = zeros([1,num_lbls]);
	conv_scores = zeros([1,num_lbls]);
	sprd_scores = zeros([1,num_lbls]);
	mod_scores = zeros([1,num_lbls]);
	nbr_scores = zeros([1,num_lbls]);
	unbr_scores = zeros([1,num_lbls]);
	for i = 1:num_lbls
		lbl = lbl_mat(:,i);
		k = length(unique(lbl));
		[convg,sprd] = ppr_affinity(adj,lbl);
		nbr = nbr_affinity(adj,lbl,1);
		unbr = unbr_affinity(adj,lbl,1);

		ari_scores(i) = adjrand(lbl,truth);
		perm_scores(i) = permanence(adj,lbl)*k;
		conv_scores(i) = sum_func(diag(convg(:,lbl)),k);
		sprd_scores(i) = sum_func(diag(sprd(:,lbl)),k);
		mod_scores(i) = modularity(adj,lbl)*k;
		nbr_scores(i) = sum_func(diag(nbr(:,lbl)),k);
		unbr_scores(i) = sum_func(diag(unbr(:,lbl)),k);
	end
	x = 1:num_lbls;
	ari_scores = normalize(ari_scores);
	perm_scores = normalize(perm_scores);
	conv_scores = normalize(conv_scores);
	sprd_scores = normalize(sprd_scores);
	mod_scores = normalize(mod_scores);
	nbr_scores = normalize(nbr_scores);
	unbr_scores = normalize(unbr_scores);
	matrix = [x;ari_scores;perm_scores;conv_scores;sprd_scores;mod_scores;nbr_scores;unbr_scores]';
	csvwrite('matrix.csv',matrix)
	%plot(x,ari_scores,x,conv_scores,x,sprd_scores,x,mod_scores,x,nbr_scores,x,unbr_scores);
end

function stb = stability(aff_mat,lbl)
	n = size(aff_mat,1);
	stb = diag(aff_mat(:,lbl));
	% normalize
	max_item = max(stb);
	min_item = min(stb);
	for i = 1:n
		stb(i) = (stb(i) - min_item)*15/(max_item - min_item) + 5;
	end
end

function summed = sum_func(vec,k)
	summed = sum(vec)*k;
end

function norm_vec = normalize(vec)
	norm_vec = vec/sum(vec);
end