function An = Normalize_Similarity_2(A)
% An = D^{-1/2} A D^{-1/2}
% where D = diag(sum(A))

d = sum(A);
An = bsxfun(@rdivide, bsxfun(@rdivide, A, sqrt(d)+eps), sqrt(d)'+eps);