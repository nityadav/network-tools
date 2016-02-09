% function to get the affinity vector of a query point to a set of clusters
function ret=lpcn(centers, query, bounding_box)
  %% estimate number of points and dimensions
  n = size(centers,1);
  dim = size(centers,2);
  dim_query = size(query,2);
  if dim_query ~= dim
      error('The dimensions of query point does not match with those of the cluster representatives.');
      return;
  elseif (dim ~= 2)
      error('This method only works for points in 2 dimensions now');
      return;
  endif
  % create all possible combinations of points including the query point
  all_points = [centers;query];
  combns = [];
  if dim == 2
      for i = 1:n
          for j = i+1:n
              combns = [combns;n+1 i j];
          endfor
      endfor
  elseif dim == 3
      for i = 1:n
          for j = i+1:n
              for k = j+1:n
                  combns = [combns;n+1 i j k];
              endfor
          endfor
      endfor
  endif

  %% to be used for octave
  circle = circumcircle(all_points,combns);
  cc = circle(:,1:2);

  %% Find the circumcenters that form the boundary of voronoi cell of query point
  neighbors = zeros([n,1]); % each row i would contain the circumcenters which are closest to ith cluster representative
  for i = 1:size(cc,1) % loop through circumcenters
      all_dists = dists(cc(i,1:dim),all_points,dim);
      min_dist = min(all_dists);
      if abs(all_dists(end) - min_dist) < (10^-4) % this checks if the circumcenter i is one of the vertices of vornoi cell of our query point
          %indxs = find(abs(all_dists - min_dist) < (10^-4)); % indxs would contain the cluster representatives which are vertices of the triangle which has circumcenter i 
          indxs = combns(i,2:dim+1);
          for j = 1:length(indxs)
              if (dim == 2) && (neighbors(indxs(j)) == 2) % if there are already two vertices defining boundary
                  if first_two_similar(cc(neighbors(indxs(j), 2),1:dim), cc(neighbors(indxs(j), 3),1:dim), cc(i,1:dim))
                      neighbors(indxs(j), 3) = i; % replace any one of the two
                  endif
              else
                  neighbors(indxs(j)) = neighbors(indxs(j)) + 1; % first column is the count of the rest of the items (circumcenters) in the row
                  neighbors(indxs(j), neighbors(indxs(j)) + 1) = i;
              endif
          endfor
      endif
  endfor

  %% Compute the Laplacian affinity
  ret = zeros([n,1]);
  for i = 1:n
      if neighbors(i) ~= 0
          if dim == 2 % compute the length of facet
              pair1 = [all_points(n+1,1:dim); all_points(i,1:dim)];
              if neighbors(i) == 2
                  pair2 = [cc(neighbors(i,2),1:dim); cc(neighbors(i,3),1:dim)];
              elseif neighbors(i) == 1
                  % get the length of one point with the intersection of the
                  % bounding box
                  bounding_points = box_line_intersection(bounding_box, all_points(n+1,1:dim), all_points(i,1:dim));
                  if ismember(i, nearest_neighbors(all_points, bounding_points(1,1:2)))
                      pair2 = [cc(neighbors(i,2),1:dim); bounding_points(1,1:2)];
                  else
                      pair2 = [cc(neighbors(i,2),1:dim); bounding_points(2,1:2)];
                  endif
              else
                  for j = 1:neighbors(i)
                      cc(neighbors(i,j+1),1:dim)
                  endfor
                  error('More than 2 points found for a shared voronoi edge in 2-dimensions');
              endif
              ret(i) = pdist(pair2,'euclidean')/pdist(pair1,'euclidean');
          else % compute the polyarea -- THIS MIGHT BE WRONG if the shared facet is infinte
              if neighbors(i) >= 3
                  x_coords = [];
                  y_coords = [];
                  z_coords = [];
                  for j = 1:neighbors(i)
                      x_coords = [x_coords; cc(neighbors(i,j),1)];
                      y_coords = [y_coords; cc(neighbors(i,j),2)];
                      z_coords = [z_coords; cc(neighbors(i,j),3)];
                  endfor
              endif
          endif
      endif
  endfor
  % Normalize the values
  sum_lp = sum(ret);
  ret = ret/sum_lp;
endfunction
