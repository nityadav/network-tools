function W = nmfr(S, r, alpha, max_iter, check_step, rsteps, verbose, W0, nSeed)
%
% compute NMFR clustering
% input:
%   S             normalized nonnegative similarity matrix (n times n)
%   r             number of clusters
%   alpha         random walk extent, (between 0 and 1, default 0.8)
%   max_iter      maximum number of iterations (default 10000)
%   check_step    duration for checking (default max_iter / 10)
%   rsteps        iterative steps for solving (I-alpha*S)\W (default 100)
%   W0            initial guess of W (default random initialization)
%   nSeed         random seed, used for random initialization if W0 is not
%                 provided (default 0)
% output:
%   W             the cluster assigning probabilities (n times r)
%
% Zhirong Yang, October 3, 2012
% 
n = size(S,1);
small_scale = n<8000;

if ~exist('alpha','var') || isempty(alpha)
    alpha = 0.8;
end

if ~exist('max_iter','var') || isempty(max_iter)
    max_iter = 10000;
end

if ~exist('check_step','var') || isempty(check_step)
    check_step = max(1, max_iter / 10);
end

if ~exist('rsteps','var') || isempty(rsteps)
    rsteps = 100;
end

if ~exist('nSeed','var') || isempty(nSeed)
    nSeed = 0;
end
if ~exist('W0', 'var') || isempty(W0)
    rand('seed', nSeed);
    W0 = rand(n,r);
end

W = W0;

if small_scale
    A = pinv(eye(n)-alpha * S);
    coef = r / sum(sum(A));
else
    coef = r / IterateTracer(alpha, S, ones(n,1), rsteps);
end

for iter=1:max_iter
    W_old = W;
    if mod(iter,check_step)==0 && verbose
        fprintf('iter=% 5d ', iter);
    end
    
    if small_scale
        F = A*W;
    else
        F = IterateSolver(alpha, S, W, rsteps);
    end
    F = F * coef;
    MW = bsxfun(@times, sum(W.^2,2), W);
    W = W .* (F+W*(W'*MW))./(MW+W*(W'*F)+eps);
    W = max(W, eps);
    W = W / (norm(W)+eps);
    
    if mod(iter,check_step)==0 && verbose
        diffW = norm(W_old-W, 'fro') / norm(W_old, 'fro');
        if verbose
            fprintf('diff=%.10f, ', diffW);
            fprintf('\n');
        end
    end
end

function y = IterateSolver(alpha, S, x, niter)
if ~exist('niter','var') || isempty(niter)
    niter = 100;
end
y = x;
for iter=1:niter
    y = alpha * S * y + ( 1 - alpha ) * x;
end
y = y / (1-alpha);

function b = IterateTracer(alpha, S, U, niter)
Ystar = IterateSolver(alpha, S, U, niter);
b = sum(sum(U.*Ystar));
