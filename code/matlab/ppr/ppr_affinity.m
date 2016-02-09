% function that gives the PPR matrix: PPR(u,v) = personalized pagerank of v with source as u
% adj: NxN adjacency matrix
% K: number of clusters
% labels: NxK matrix denoting the initial labeling
% Toaffinity: NxK denoting To-affinities of N vertices towards K clusters
% Fromaffinity: NxK denoting From-affinities of N vertices towards K clusters

function [from_aff, to_aff] = ppr_affinity(adj,labels)
  % hyper-parameters start
  jump = 0.15;
  walklen = 30;
  % hyper-parameters end
  n = size(adj,1);
  clusters = unique(labels);
  k = length(clusters);
  mem_mat = zeros([n,k]);
  % for vertices having no out-edges, put an edge to themselves, which makes them absorbing
  % also update membership-indicator matrix
  for i = 1:n
    if not(any(adj(i,:)))
      adj(i,i) = 1;
    end
    mem_mat(i,find(clusters == labels(i))) = 1;
  end
  % get the degree matrix
  deg = diag(sum(adj,2));
  % for each source vertex there is a special walk (or trans matrix)
  pprmat = zeros([n,n]);
  for u = 1:n
    % build transition matrix considering the jump factor
    ppradj = adj*(1-jump);
    for j = 1:n
      ppradj(j,u) = ppradj(j,u) + deg(j,j)*jump;
    end
    trans = deg\ppradj;
    % start the random walk with no. of steps = walklen
    pdist = zeros([1,n]);
    pdist(u) = 1;
    pdist = pdist*mpower2(trans,walklen);
    pprmat(u,1:n) = pdist;
  end
  % We have the ppr computed now. Let's calculate the affinities as sum of PPRs
  to_aff = pprmat*mem_mat;
  from_aff = pprmat'*mem_mat;
  % normalize from_aff, to_aff comes normalized
  for i = 1:n
    from_aff(i,:) = from_aff(i,:)./sum(from_aff(i,:));
  end
end