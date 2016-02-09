% function gives a list of distance of 'from' point to 'tolist' points in 'dim' dimensions
function ret=dists(from, tolist, dim)
  pair = [];
  ret = [];
  for i = 1:size(tolist,1)
    pair = [from;tolist(i,1:dim)];
    ret = [ret pdist(pair,'euclidean')];
  end
end
