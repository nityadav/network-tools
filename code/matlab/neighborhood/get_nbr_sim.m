function sim_mat = get_nbr_sim(adj,weight)
    tic
	n = size(adj,1);
	adj2 = adj*adj;
	deg = sum(adj,2);
	deg_mat = repmat(deg,1,n) + repmat(deg',n,1);
	sim_mat = adj2./deg_mat + weight*adj;
    toc
end