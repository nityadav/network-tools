addpath 1SpectralClustering;
addpath Ncut_9;

datanames = ReadLines('datalist.txt');
nd = length(datanames);

methods = {...
    'Ncut', ...
    'PNMF', ...
    'NSC', ...
    'ONMF', ...
    'PLSI', ...
    'LSD', ...
    '1-Spec', ...
    'DCD', ...
    'NMFR', ...
    };
nm = length(methods);

max_iter = 10000;
check_step = 1000;
rsteps = 100;
nSeed = 0;
verbose = false;
candidate_alphas = [linspace(0.1,0.9,9),0.99];

warning('off');

purity = zeros(nd,nm);

for di=1:nd
    dataname = datanames{di};
    fprintf('di=%d \t%10s ', di, dataname);
    
    clear A C nc;
    [A,C,nc] = GetClusteringData(dataname);
    if isempty(A)
        fprintf('No such data!\n');
        continue;
    end
    
    n = size(A,1);
    
    W0 = ncutW(A, nc, nSeed);
    [~,idx] = max(W0,[],2);
    purity(di,1) = ComputeClusterPurity(idx, C, nc);
    fprintf('\tNcut:%.2f', purity(di,1));
    
    An = Normalize_Similarity_2(A);
    
    W0 = W0 + 0.2;
    for mi=2:nm
        method = methods{mi};
        fprintf('\t%s:', method);
        switch method
            case 'PNMF'
                W = pnmf(A, max_iter, W0);
            case 'NSC'
                W = nsc(A, max_iter, W0);
            case 'ONMF'
                W = onmf(A, max_iter, W0);
            case 'PLSI'
                [W,s] = plsi(A, max_iter, W0);
                W = bsxfun(@times, W, s');
                W = bsxfun(@rdivide, W, sum(W,2)+eps);
            case 'LSD'
                W = lsd(A, max_iter, W0);
            case '1-Spec'
                [clusters,~,~] = OneSpectralClustering(A, 'rcc', nc, 0, 0, 0);
                W = full(clabel2dataclasses(clusters(:,end),nc));
            case 'DCD'
                W = dcd(A, nc, 1, max_iter, W0+0.2, nSeed);
            case 'NMFR'
                if n<8000
                    [W, bestalpha, ~] = nmfr_auto(An, nc, candidate_alphas, max_iter, check_step, verbose, W0, nSeed);
                else
                    alpha = 0.8;
                    W = nmfr(An, nc, alpha, max_iter, check_step, rsteps, verbose, W0, nSeed);
                end
        end
        [~,idx] = max(W,[],2);
        purity(di,mi) = ComputeClusterPurity(idx, C, nc);
        
        fprintf('%.2f', purity(di,mi));
        
        save('results_clustering_test.mat', ...
            'datanames', 'methods', ...
            'max_iter', 'verbose', 'nSeed', 'check_step', 'rsteps', 'candidate_alphas', ...
            'purity');
    end
    fprintf('\n');
end         



