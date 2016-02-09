% This function returns the affinity of a set of points towards clusters
function affinity = nnaffinity(points,clusters,err)
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
  % for each point get the affinity
  affinity = [];
  for i = 1:n
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
        affinity(i,j) = nnz(sampleclosest==j)/numsamples;
    end
  end
end
