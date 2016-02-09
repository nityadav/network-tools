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