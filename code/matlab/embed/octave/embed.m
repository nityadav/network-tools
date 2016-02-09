% function to embed a graph in Euclidean space
% This is an implementation of the paper: Directed Graph Embedding
function ret=embed(adj,dim=2,jump=0.95,walklen=30)
  n = size(adj,1);
  % change the matrix such that the nodes which have out-degree = 0, are connected to all the nodes
  for i=1:n
    if not(any(adj(i,:)))
      adj(i,:) = 1;
    endif
  endfor
  % finding stationary distribution
  deg = get_degree(adj);
  trans = jump*((deg^-1)*adj) + (1-jump)*(1/n)*ones(n);
  dist = ones([1,n]);
  for i=1:walklen
    dist = dist*trans;
  endfor
  norm = sum(dist);
  dist = diag(dist/norm);
  % construct laplacian
  L = dist - (dist*trans + trans'*dist)/2;
  [V,D] = eig(L,dist);
  X = V(:,2);
  Y = V(:,3);
  scatter(X,Y);
  ret = [X Y];
endfunction
