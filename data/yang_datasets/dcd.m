function [W,cross_entropy] = dcd(A, r, alpha, max_iter, W0, nSeed)
%
% compute DCD clustering
% input:
%   A             nonnegative similarity matrix (n times n)
%   r             number of clusters
%   alpha         Dirichlet prior parameter, (default 1)
%   max_iter      maximum number of iterations (default 10000)
%   W0            initial guess of W (default random initialization)
%   nSeed         random seed, used for random initialization if W0 is not
%                 provided (default 0)
% output:
%   W             the cluster assigning probabilities (n times r)
%   cross_entroy  used for selecting the best among multiple dcd runs
%
% Zhirong Yang, June 21, 2012
% 
n = size(A,1);

if ~exist('alpha','var') || isempty(alpha)
    alpha = 1;
end

if ~exist('max_iter','var') || isempty(max_iter)
    max_iter = 10000;
end


if ~exist('nSeed','var') || isempty(nSeed)
    nSeed = 0;
end
if ~exist('W0', 'var') || isempty(W0)
    rand('seed',nSeed);
    W0 = rand(n,r);
end
W0 = bsxfun(@rdivide, W0, sum(W0,2)+eps);

W = W0;
for iter=1:max_iter
    inv_s = 1./(sum(W)+eps);
    inv_W = 1./(W+eps);
    Z = sp_factor_ratio(A, bsxfun(@times, W, inv_s), W');
    ZW = Z*W;
    gradn = bsxfun(@times, 2*ZW, inv_s)+alpha*inv_W;
    gradp = bsxfun(@plus, diag(W'*ZW)'.*inv_s.^2, inv_W);
    a = sum(W./(gradp+eps),2);
    b = sum(W.*gradn./(gradp+eps),2);
    W = W .* (bsxfun(@times, gradn, a) + 1) ./ (bsxfun(@plus, bsxfun(@times, gradp, a), b)+eps);    
end

[I,J,Anz] = find(A);
Ahat = sum(bsxfun(@rdivide, sp_factor(I,J,W,W'), sum(W)+eps),2);
cross_entropy = -Anz'*log(Ahat+eps);


