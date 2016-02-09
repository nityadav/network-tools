function [RI,JI] = rand_jaccard_indices(label,truth)
    n = length(label);
    N = zeros(2,2);
    for i = 1:n
        for j = i+1:n
            N((label(i)==label(j))+1,(truth(i)==truth(j))+1) = N((label(i)==label(j))+1,(truth(i)==truth(j))+1) + 1;
        end
    end
    RI = (N(1,1) + N(2,2))/sum(N(:));
    JI = N(2,2)/(N(1,2) + N(2,1) + N(2,2));
end