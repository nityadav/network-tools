function [W, alpha, objs] = nmfr_auto(S, r, candidate_alphas, max_iter, check_step, verbose, W0, nSeed)
%
% compute NMFR clustering for small-scale data, automatically selecting the random walk extent
% input:
%   S                  normalized nonnegative similarity matrix (n times n)
%   r                  number of clusters
%   candidate_alphas   random walk extent candidates, (default [linspace(0.1,0.9,9),0.99])
%   max_iter      maximum number of iterations (default 10000)
%   check_step    duration for checking (default max_iter / 10)
%   W0            initial guess of W (default random initialization)
%   nSeed         random seed, used for random initialization if W0 is not
%                 provided (default 0)
% output:
%   W             the cluster assigning probabilities (n times r)
%
% Zhirong Yang, October 3, 2012
% 
n = size(S,1);
if ~exist('candidate_alphas', 'var') || isempty(candidate_alphas)
    candidate_alphas = [linspace(0.1,0.9,9),0.99];
end
if ~exist('max_iter', 'var') || isempty(max_iter)
    max_iter = 10000;
end
if ~exist('check_step', 'var') || isempty(check_step)
    check_step = max(1,round(max_iter/10));
end
if ~exist('verbose', 'var') || isempty(verbose)
    verbose = false;
end
if ~exist('nSeed', 'var') || isempty(nSeed)
    nSeed = 0;
end
rand('seed', nSeed);
if ~exist('W0', 'var') || isempty(W0)
    W0 = rand(n,r);
end

W = W0;

max_iter_out = 10;
na = length(candidate_alphas);
alpha0 = 0.8;
alpha = alpha0;

for iter_out = 1:max_iter_out
    if verbose
        fprintf('=============== iter_out=%d ===================\n', iter_out);
        fprintf('alpha=%.8f\n', alpha);
    end

    % optimize over alpha
    if iter_out>1
        alpha_old = alpha;
    end
    
    objs = zeros(na,1);
    U = discretize(W);
    U = U(:,sum(U)>0);
    U = bsxfun(@rdivide, U, sqrt(sum(U)));
    for ai=1:na
        alphai = candidate_alphas(ai);
        A = pinv(eye(n)-alphai * S);
        A = A / sum(sum(A));
        objs(ai) = norm(A-U*U'/r, 'fro');
        if verbose
            fprintf('ai=%d, alphai=%.8f, obj=%.12f\n', ai, alphai, objs(ai));
        end
    end
    [~,ind] = min(objs);
    alpha = candidate_alphas(ind);
    if iter_out>1 && alpha==alpha_old
        break;
    end
    
    A = pinv(eye(n)-alpha * S);
    coef = r / sum(sum(A));

    for iter=1:max_iter
        W_old = W;
        if mod(iter,check_step)==0 && verbose
            fprintf('iter=% 5d ', iter);
        end
        
        F = A*W;
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
end

function Wd = discretize(W)
[~,ind] = max(W,[],2);
n = size(ind,1);
Wd = full(sparse((1:n)', ind, ones(n,1), n, size(W,2)));