% function to embed a graph in Euclidean space
% This is an implementation of the paper: Directed Graph Embedding
function affinity=embedwithclusteraffinity(adj,k,labels,dim)
	jump = 0.95;
	walklen = 30;
  n = size(adj,1);
	% the maximum value of dim can be n-1
	if dim > n-1
		error('Dimensions can not be more than or equal to the number of vertices');
	end
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
	% form the points
	points = V(:,2:1+dim);
  fprintf('Embedding Completed.');
  % get the cluster centers
  centers = zeros([k,dim]);
  for cluster = 1:k
    members = find(labels==cluster);
    member_points = points(members,:);
    center = mean(member_points);
    centers(cluster,:) = center;
  end
  % get the affinity matrix using natural neighbors
  affinity = nnaffinity(points,centers,0.01);
end
