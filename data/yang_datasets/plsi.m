function [W,s] = plsi(A, max_iter, W0)
W = W0;
r = size(W0,2);
s = ones(r,1)/r;

W = bsxfun(@rdivide, W, sum(W)+eps);
s = s / sum(s);

for iter=1:max_iter
    Z = sp_factor_ratio(A, bsxfun(@times, W, s'), W');
    W = W .* (Z * W);
    W = bsxfun(@rdivide, W, sum(W)+eps);
    
    Z = sp_factor_ratio(A, bsxfun(@times, W, s'), W');
    s = s .* diag(W'*Z*W);
    s = s / sum(s);
end