function W = nsc(A, max_iter, W0)
W = W0;
for iter=1:max_iter
    AW = A*W;
    W = W .* sqrt(AW./(bsxfun(@times, sum(A,2), W*(W'*AW))+eps));
end
