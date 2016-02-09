% function to embed a graph in Euclidean space
% This is an implementation of the paper: Directed Graph Embedding
function [points centers]=embedwithcluster(adj,k,cluster,dim=2,jump=0.95,walklen=30)
  n = size(adj,1);
  % change the matrix such that the nodes which have out-degree = 0, are connected to all the nodes
  for i=1:n
    if not(any(adj(i,:)))
      adj(i,:) = 1;
    end
  end
  % finding stationary distribution
  deg = get_degree(adj);
  trans = jump*((deg^-1)*adj) + (1-jump)*(1/n)*ones(n);
  dist = ones([1,n]);
  for i=1:walklen
    dist = dist*trans;
  end
  norm = sum(dist);
  dist = diag(dist/norm);
  % construct laplacian and embed the graph
  L = dist - (dist*trans + trans'*dist)/2;
  [V,D] = eig(L,dist);
  X = V(:,2);
  Y = V(:,3);
  scatter(X,Y);
  points = [X Y];
  % get the cluster centers
  centers(k,2) = 0;
  numpoints(k,1) = 0;
  if length(cluster) ~= n
    error('size of cluster map must be equal to no. of nodes');
  end
  for i=1:n
    centers(cluster(i),1) = centers(cluster(i),1) + points(i,1); % x coordinate
    centers(cluster(i),2) = centers(cluster(i),2) + points(i,2); % y coordinate
    numpoints(cluster(i)) = numpoints(cluster(i)) + 1;
  end
  centers = rdivide(centers,numpoints);
  %scatter(centers(:,1),centers(:,2));
end
