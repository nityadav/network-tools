% Function that returns equation of a half-plane in form Ax <= b
% Input is two points (row vectors), which are equidistant from the hyperplane
% The first point belongs to the half-plane region
function [A,b] = halfplane(p1,p2)
  dim = length(p1);
  if length(p2) ~= dim
    error('Both the points should be in same number of dimensions.');
  end
  midpoint = (p1+p2)/2;
  normal = p1-p2;
  b = dot(normal,midpoint);
  if dot(p1,normal) <= b
    A = normal;
  else
    A = (-1)*normal;
    b = (-1)*b;
  end
end
