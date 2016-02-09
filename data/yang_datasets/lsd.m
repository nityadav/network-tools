function W = lsd(A, max_iter, W0)
[n,r] = size(W0);

W0 = bsxfun(@rdivide, W0, sum(W0,2)+eps);

if n<8000
    c = abs(sum(sum(pinv(full(A)))))/r;
else
    [E,D,~] = svds(A,30);
    M = bsxfun(@rdivide, E, sqrt(diag(D))'+eps);
    c = norm(sum(M))^2/r;
end

W = W0;
for iter=1:max_iter
    gradn = c*A*W;
    gradp = W*(W'*W);
    a = sum(W./(gradp+eps),2);
    b = sum(W.*gradn./(gradp+eps),2);
    W = W .* (bsxfun(@times, gradn, a) + 1) ./ (bsxfun(@plus, bsxfun(@times, gradp, a), b)+eps);    
end