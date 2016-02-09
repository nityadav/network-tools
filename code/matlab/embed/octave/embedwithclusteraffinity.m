% function to embed a graph in Euclidean space
% This is an implementation of the paper: Directed Graph Embedding
function affinity=embedwithclusteraffinity(adj,k,cluster,dim=2,jump=0.95,walklen=30)
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
  % construct laplacian and embed the graph
  L = dist - (dist*trans + trans'*dist)/2;
  [V,D] = eig(L,dist);
  X = V(:,2);
  Y = V(:,3);
  %scatter(X,Y);
  points = [X Y];
  % get the cluster centers
  centers(k,2) = 0;
  numpoints(k,1) = 0;
  if length(cluster) ~= n
    error('size of cluster map must be equal to no. of nodes');
  endif
  for i=1:n
    centers(cluster(i),1) = centers(cluster(i),1) + points(i,1); % x coordinate
    centers(cluster(i),2) = centers(cluster(i),2) + points(i,2); % y coordinate
    numpoints(cluster(i)) = numpoints(cluster(i)) + 1;
  endfor
  centers = rdivide(centers,numpoints);
  % get the affinity matrix using laplacian interpolation
  X_mean = mean(X);
  X_std = std(X);
  Y_mean = mean(Y);
  Y_std = std(Y);
  % construct bounding box
  box = [X_mean - 6*X_std X_mean + 6*X_std; Y_mean - 6*Y_std Y_mean + 6*Y_std];
  stability(1:n) = 0;
  % find stability
  for i = 1:n
    affinity(i,1:k) = lpcn(centers,points(i,:),box);
  endfor
endfunction
