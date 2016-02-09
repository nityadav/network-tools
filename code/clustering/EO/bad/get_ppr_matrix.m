function sim_mat = get_ppr_matrix(adj)
	% hyper-parameters start
  	jump = 0.15;
  	walklen = 30;
  	% hyper-parameters end
  	n = size(adj,1);
  	% for vertices having no out-edges, put an edge to themselves, which makes them absorbing
  	% also update membership-indicator matrix
  	for i = 1:n
    	if not(any(adj(i,:)))
      		adj(i,i) = 1;
    	end
  	end
  	% get the degree matrix
  	deg = diag(sum(adj,2));
  	% for each source vertex there is a special walk (or trans matrix)
  	sim_mat = zeros([n,n]);
  	for u = 1:n
    	% build transition matrix considering the jump factor
    	ppradj = adj*(1-jump);
    	for j = 1:n
      		ppradj(j,u) = ppradj(j,u) + deg(j,j)*jump;
    	end
    	trans = deg\ppradj;
    	% start the random walk with no. of steps = walklen
    	pdist = zeros([1,n]);
    	pdist(u) = 1;
    	pdist = pdist*mpower2(trans,walklen);
    	sim_mat(u,1:n) = pdist;
    end
end