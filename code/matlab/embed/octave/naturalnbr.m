% function that returns affinity matrix of query points to centers
function ret=naturalnbr(centers, queries)
% estimate number of points and dimensions
nc = size(centers,1);
nq = size(queries,1);
dimc = size(centers,2);
dimq = size(queries,2);
if dimq ~= dimc
    error('The dimensions of query point does not match with those of the cluster representatives.');
    return;
elseif (dimc ~= 2)
    error('This method only works for points in 2 dimensions now');
    return;
end

% construct the interpolant
values(1:nc) = 0;
values = transpose(values);
nn_interpolant = scatteredInterpolant(centers, values);
nn_interpolant.Method = 'natural';

%% Get the affinity
for i=1:nc
    values(i) = 1;
    if i>1
        values(i-1) = 0;
    end
    nn_interpolant.Values = values;
    affinities = transpose(nn_interpolant(queries));
    for j=1:nq
        if ~if_inhull(j)
            stability(j) = 1;
        else
            stability(j) = max(stability(j),affinities(j));
        end
    end
end

ret = affinity;
endfunction
