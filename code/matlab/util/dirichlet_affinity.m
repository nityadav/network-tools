% get dirichlet-affinity
function affinity=dirichlet_affinity(adj,k,label)
    n = size(adj,1);
    deg = diag(sum(adj,2));
	lpcn = deg - adj;
	normlpcn = (deg^(-1/2))*lpcn*(deg^(-1/2));
    affinity = zeros([n,k]);
    % calculate for the clusters
    for c = 1:k
      members = find(ismember(label,c));
      subset = normlpcn(members,members);
      [V,E] = eigs(subset,1,'sm');
      affinity(members,c) = V;
    end
    % calculate for the non-clusters
    for v = 1:n
        for c = 1:k
            if c == label(v)
                continue;
            end 
            members = find(ismember(label,c));
            members = [members v];
            v
            subset = normlpcn(members,members);
            [V,E] = eigs(subset,1,'sm')
            affinity(v,c) = V(end);
        end
    end
    % normalize the affinity
    affinity = abs(affinity);
    for i = 1:n
        affinity(i,:) = affinity(i,:)/sum(affinity(i,:)); 
    end
end