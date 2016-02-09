function [A,C,nc] = GetClusteringData(dataname)
filename = ['data/', dataname, '.mat'];
if isempty(dir(filename))
    A = [];
    C = [];
    nc = 0;
    return;
end

load(filename);

if ~exist('C', 'var') || isempty(C)
    C = ones(size(A,1),1);
end

if ~exist('nc', 'var') || isempty(nc)
    nc = numel(unique(C));
end

A = double(A+A'>0);

[C,ind] = sort(C);
A = A(ind,ind);

n = size(A,1);
for i=1:n
    A(i,i) = 0;
end
if ~issparse(A);
    A = sparse(A);
end