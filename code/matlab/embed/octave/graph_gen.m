% function to generate clustered graph
% nodes: an array with no. of nodes required in each cluster
% edges: an array with no. of edges required in each cluster
function ret=graph_gen(nodes,edges,bridges)
  n = sum(nodes);
  k = length(nodes);
  if k ~= length(edges)
    error('size of both the parameters should be equal');
  endif  
  adj = zeros(n);
  % for each cluster
  for i = 1:k
    % loop until you generate the no. of edges reqd. for that cluster
    if i==1
      minnode(i) = 1;
    else
      minnode(i) = maxnode(i-1) + 1;
    endif
    maxnode(i) = minnode(i) + nodes(i) - 1; 
    clust_edges = randi([minnode(i),maxnode(i)],[edges(i),2]);
    for j = 1:size(clust_edges,1)
      adj(clust_edges(j,1),clust_edges(j,2)) = 1;
    endfor
  endfor
  % now generate some 'bridge' edges between clusters
  for i = 1:bridges
    srcclstr = randi(k);
    desclstr = randi(k);
    while srcclstr == desclstr
      desclstr = randi(k);
    endwhile
    src = randi([minnode(srcclstr),maxnode(srcclstr)]);
    des = randi([minnode(desclstr),maxnode(desclstr)]);
    adj(src,des) = 1;
  endfor
  ret = adj;
endfunction
