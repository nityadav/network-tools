function W = pnmf(A, max_iter, W0)
W = W0;
for iter=1:max_iter
    AW = A*W;
    W = W .* AW ./(W*(W'*AW)+AW*(W'*W)+eps);
    W = max(W,eps);
    W = W / norm(W);
end
