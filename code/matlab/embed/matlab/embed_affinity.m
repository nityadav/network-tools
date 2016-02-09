% function to embed a graph in Euclidean space
% This is an implementation of the paper: Directed Graph Embedding
function affinity = embed_affinity(adj,k,labels,dim,s)
	jump = 0.85;
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
  % get the cluster centers
  centers = zeros([k,dim]);
  for cluster = 1:k
    members = find(labels==cluster);
    members = members(members~=s);
    member_points = points(members,:);
    center = mean(member_points);
    centers(cluster,:) = center;
  end
  % get the affinity matrix using natural neighbors
  affinity = nnaffinity(points,centers,s,0.01);
end

% This function returns the affinity of a set of points towards clusters
function affinity = nnaffinity(points,clusters,src,err)
  dim = size(points,2);
  k = size(clusters,1);
  n = size(points,1);
  if size(clusters,2) ~= dim
   error('Points and Cluster centers must be in same dimensions.');
  end
  numsamples = round(dim/(err^2)*log2(1/err));
  % build bounding box 2X times (in each dimension) the bounding box containing all the points
  sites = [clusters; points];
  boxA = zeros([2*dim,dim]);
  boxB = zeros([2*dim,1]);
  for i = 1:dim
      minval = min(sites(:,i));
      maxval = max(sites(:,i));
      boxA(2*i,i) = 1;
      boxB(2*i) = 2*maxval;
      boxA(2*i-1,i) = -1;
      boxB(2*i-1) = -2*minval;
  end
  affinity = zeros([1,k]);
  % make the voronoi cell polytope using halfplanes in the form Ax <= B
  A = [];
  B = [];
  for j = 1:k
    [a b] = halfplane(points(i,:),clusters(j,:));
    A = [A;a];
    B = [B;b];
  end
  % add the boudning box halfplanes
  A = [A;boxA];
  B = [B;boxB];
  % sample points from this polytope
  samples = cprnd(numsamples,A,B);
  % for each sample find closest cluster center and calculate affinity
  %T = delaunayn(clusters); % might be used for speed-up
  sampleclosest = dsearchn(clusters,samples);
  for j = 1:k
    affinity(j) = nnz(sampleclosest==j)/numsamples;
  end
end
