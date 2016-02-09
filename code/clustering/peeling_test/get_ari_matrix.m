function Rtable = get_ari_matrix(adj,truth,trials)
	weights = [0 0.5 1 2 3 4 5 6];
	limits = [0 1 2 3 4 5 6 10000];
	Rtable = zeros([length(weights)+1,length(limits)+1]);
	for t = 1:trials
		temp1 = zeros([length(weights)+1,length(limits)+1]);
		temp1(1,2:end) = limits;
		temp1(2:end,1) = weights;
		for i = 1:length(weights)
			w = weights(i);
			for j = 1:length(limits)
				l = limits(j);
				%labels = nbr_det(adj,w,l);
				%labels = nbr_prb(adj,w,l);
				%labels = unbr_det(adj,w,l);
				labels = unbr_prb(adj,w,l);
				temp1(i+1,j+1) = adjrand(labels,truth);
			end
		end
		Rtable = Rtable + temp1;
	end
	Rtable = Rtable/trials;
	csvwrite('table.csv',Rtable);
end