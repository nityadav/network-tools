function W = onmf(A, max_iter, W0)
W = W0;
S = W'*A*W;
for iter=1:max_iter
    AWS = A*W*S;
    W = W .* AWS ./ (W*(W'*AWS)+eps);
    W = max(W,eps);
    WW = W'*W;
    S = S .* (W'*A*W) ./ (WW*S*WW+eps);
    S = max(S,eps);
end
