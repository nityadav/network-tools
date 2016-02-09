% get affinity using PPR method
function affinity = ppr_affinity(adj,k,labels,s)
  teleport = 0.15;
  walklen = 30;
  num_nodes = size(adj,1);
  % for vertices having no out-edges, put an edge to themselves, which makes them absorbing
  outdeg = diag(sum(adj,2));
  for i = 1:num_nodes
    if outdeg(i,i) == 0
      adj(i,i) = 1;
    end
  end
  outdeg = diag(sum(adj,2));
  ppr = zeros([1,num_nodes]);
  ppradj = adj*(1-teleport);
  for j = 1:num_nodes
    ppradj(j,s) = ppradj(j,s) + outdeg(j,j)*teleport;
  end
  trans = outdeg\ppradj;
  pdist = zeros([1,num_nodes]);
  pdist(s) = 1;
  ppr = pdist*(trans^walklen)
  for cluster = 1:k
    affinity(cluster) = sum(ppr(find(labels==cluster)));
  end
  affinity = affinity./sum(affinity);
end
