% function that gives the PPR matrix: PPR(u,v) = personalized pagerank of v with source as u
function pprmat = ppr(adj)
  jump=0.15;
  walklen=30;
  n = size(adj,1);
  % for vertices having no out-edges, put an edge to themselves, which makes them absorbing
  for i=1:n
    if not(any(adj(i,:)))
      adj(i,i) = 1;
    end
  end
  % get the degree matrix
  deg = diag(sum(adj,2));
  % for each source vertex there is a special walk (or trans matrix)
  for u = 1:n
    % build transition matrix considering the jump factor
    ppradj = adj*(1-jump);
    for j = 1:n
      ppradj(j,u) = ppradj(j,u) + deg(j,j)*jump;
    end
    trans = (deg^-1)*ppradj;
    % start the random walk with no. of steps = walklen
    pdist = zeros([1,n]);
    pdist(u) = 1;
    for step = 1:walklen
      pdist = pdist*trans;
    end
    pprmat(u,1:n) = pdist;
  end
end
