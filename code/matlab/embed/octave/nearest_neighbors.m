% function returns a vector of indices which are natural neighbors
function ret=nearest_neighbors(claimers,point)
  dim = size(claimers,2);
  point_dim = size(point,2);
  if dim ~= point_dim
    error('Dimension do not match');
    return;
  endif
  all_dists = dists(point, claimers, dim);
  min_dist = min(all_dists);
  ret = find(abs(all_dists - min_dist) < (10^-4)); % indexes of the closest claimers to point
endfunction
