% function to 
function ret=first_two_similar(point1,point2,point3)
  distance = [];
  pair12 = [point1;point2]; 
  distance = [distance pdist(pair12,'euclidean')];
  pair23 = [point2;point3]; 
  distance = [distance pdist(pair23,'euclidean')];
  pair31 = [point3;point1]; 
  distance = [distance pdist(pair31,'euclidean')];
  [m,I] = max(distance);
  if I == 1
    ret = 1;
  else
    ret = 0;
  endif
endfunction
