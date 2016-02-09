function Wd = discretize(W, return_sparse)
if ~exist('return_sparse', 'var') || isempty(return_sparse)
    return_sparse = false;
end
[~,ind] = max(W,[],2);
n = size(ind,1);
Wd = full(sparse((1:n)', ind, ones(n,1), n, size(W,2)));
if ~return_sparse
    Wd = full(Wd);
end