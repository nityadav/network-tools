results = [];

disp('Now running lfr_200_2')
A = sparse(csvread('data/lfr_200_2/adj.csv'));
L = csvread('data/lfr_200_2/lbl.csv');
[l,t] = unbr_det_fast(A);
mi = ami(L,l);
ri = adjrand(l,L);
results = [results; mi ri t];
[l,t] = unbr_det(A);
mi = ami(L,l);
ri = adjrand(l,L);
results = [results; mi ri t];
[l,t] = unbr_prb_fast(A);
mi = ami(L,l);
ri = adjrand(l,L);
results = [results; mi ri t];
[l,t] = unbr_prb(A);
mi = ami(L,l);
ri = adjrand(l,L);
results = [results; mi ri t];

disp('Now running lfr_200_3')
A = sparse(csvread('data/lfr_200_3/adj.csv'));
L = csvread('data/lfr_200_3/lbl.csv');
[l,t] = unbr_det_fast(A);
mi = ami(L,l);
ri = adjrand(l,L);
results = [results; mi ri t];
[l,t] = unbr_det(A);
mi = ami(L,l);
ri = adjrand(l,L);
results = [results; mi ri t];
[l,t] = unbr_prb_fast(A);
mi = ami(L,l);
ri = adjrand(l,L);
results = [results; mi ri t];
[l,t] = unbr_prb(A);
mi = ami(L,l);
ri = adjrand(l,L);
results = [results; mi ri t];

disp('Now running lfr_200_4')
A = sparse(csvread('data/lfr_200_4/adj.csv'));
L = csvread('data/lfr_200_4/lbl.csv');
[l,t] = unbr_det_fast(A);
mi = ami(L,l);
ri = adjrand(l,L);
results = [results; mi ri t];
[l,t] = unbr_det(A);
mi = ami(L,l);
ri = adjrand(l,L);
results = [results; mi ri t];
[l,t] = unbr_prb_fast(A);
mi = ami(L,l);
ri = adjrand(l,L);
results = [results; mi ri t];
[l,t] = unbr_prb(A);
mi = ami(L,l);
ri = adjrand(l,L);
results = [results; mi ri t];

disp('Now running lfr_500_2')
A = sparse(csvread('data/lfr_500_2/adj.csv'));
L = csvread('data/lfr_500_2/lbl.csv');
[l,t] = unbr_det_fast(A);
mi = ami(L,l);
ri = adjrand(l,L);
results = [results; mi ri t];
[l,t] = unbr_det(A);
mi = ami(L,l);
ri = adjrand(l,L);
results = [results; mi ri t];
[l,t] = unbr_prb_fast(A);
mi = ami(L,l);
ri = adjrand(l,L);
results = [results; mi ri t];
[l,t] = unbr_prb(A);
mi = ami(L,l);
ri = adjrand(l,L);
results = [results; mi ri t];

disp('Now running lfr_500_3')
A = sparse(csvread('data/lfr_500_3/adj.csv'));
L = csvread('data/lfr_500_3/lbl.csv');
[l,t] = unbr_det_fast(A);
mi = ami(L,l);
ri = adjrand(l,L);
results = [results; mi ri t];
[l,t] = unbr_det(A);
mi = ami(L,l);
ri = adjrand(l,L);
results = [results; mi ri t];
[l,t] = unbr_prb_fast(A);
mi = ami(L,l);
ri = adjrand(l,L);
results = [results; mi ri t];
[l,t] = unbr_prb(A);
mi = ami(L,l);
ri = adjrand(l,L);
results = [results; mi ri t];

disp('Now running lfr_500_4')
A = sparse(csvread('data/lfr_500_4/adj.csv'));
L = csvread('data/lfr_500_4/lbl.csv');
[l,t] = unbr_det_fast(A);
mi = ami(L,l);
ri = adjrand(l,L);
results = [results; mi ri t];
[l,t] = unbr_det(A);
mi = ami(L,l);
ri = adjrand(l,L);
results = [results; mi ri t];
[l,t] = unbr_prb_fast(A);
mi = ami(L,l);
ri = adjrand(l,L);
results = [results; mi ri t];
[l,t] = unbr_prb(A);
mi = ami(L,l);
ri = adjrand(l,L);
results = [results; mi ri t];

disp('Now running lfr_1000_2')
A = sparse(csvread('data/lfr_1000_2/adj.csv'));
L = csvread('data/lfr_1000_2/lbl.csv');
[l,t] = unbr_det_fast(A);
mi = ami(L,l);
ri = adjrand(l,L);
results = [results; mi ri t];
[l,t] = unbr_det(A);
mi = ami(L,l);
ri = adjrand(l,L);
results = [results; mi ri t];
[l,t] = unbr_prb_fast(A);
mi = ami(L,l);
ri = adjrand(l,L);
results = [results; mi ri t];
[l,t] = unbr_prb(A);
mi = ami(L,l);
ri = adjrand(l,L);
results = [results; mi ri t];

disp('Now running lfr_1000_3')
A = sparse(csvread('data/lfr_1000_3/adj.csv'));
L = csvread('data/lfr_1000_3/lbl.csv');
[l,t] = unbr_det_fast(A);
mi = ami(L,l);
ri = adjrand(l,L);
results = [results; mi ri t];
[l,t] = unbr_det(A);
mi = ami(L,l);
ri = adjrand(l,L);
results = [results; mi ri t];
[l,t] = unbr_prb_fast(A);
mi = ami(L,l);
ri = adjrand(l,L);
results = [results; mi ri t];
[l,t] = unbr_prb(A);
mi = ami(L,l);
ri = adjrand(l,L);
results = [results; mi ri t];

disp('Now running lfr_1000_4')
A = sparse(csvread('data/lfr_1000_4/adj.csv'));
L = csvread('data/lfr_1000_4/lbl.csv');
[l,t] = unbr_det_fast(A);
mi = ami(L,l);
ri = adjrand(l,L);
results = [results; mi ri t];
[l,t] = unbr_det(A);
mi = ami(L,l);
ri = adjrand(l,L);
results = [results; mi ri t];
[l,t] = unbr_prb_fast(A);
mi = ami(L,l);
ri = adjrand(l,L);
results = [results; mi ri t];
[l,t] = unbr_prb(A);
mi = ami(L,l);
ri = adjrand(l,L);
results = [results; mi ri t];

disp('Now running lfr_5000_2')
A = sparse(csvread('data/lfr_5000_2/adj.csv'));
L = csvread('data/lfr_5000_2/lbl.csv');
[l,t] = unbr_det_fast(A);
mi = ami(L,l);
ri = adjrand(l,L);
results = [results; mi ri t];
[l,t] = unbr_det(A);
mi = ami(L,l);
ri = adjrand(l,L);
results = [results; mi ri t];
[l,t] = unbr_prb_fast(A);
mi = ami(L,l);
ri = adjrand(l,L);
results = [results; mi ri t];
[l,t] = unbr_prb(A);
mi = ami(L,l);
ri = adjrand(l,L);
results = [results; mi ri t];

disp('Now running lfr_5000_3')
A = sparse(csvread('data/lfr_5000_3/adj.csv'));
L = csvread('data/lfr_5000_3/lbl.csv');
[l,t] = unbr_det_fast(A);
mi = ami(L,l);
ri = adjrand(l,L);
results = [results; mi ri t];
[l,t] = unbr_det(A);
mi = ami(L,l);
ri = adjrand(l,L);
results = [results; mi ri t];
[l,t] = unbr_prb_fast(A);
mi = ami(L,l);
ri = adjrand(l,L);
results = [results; mi ri t];
[l,t] = unbr_prb(A);
mi = ami(L,l);
ri = adjrand(l,L);
results = [results; mi ri t];

disp('Now running lfr_5000_4')
A = sparse(csvread('data/lfr_5000_4/adj.csv'));
L = csvread('data/lfr_5000_4/lbl.csv');
[l,t] = unbr_det_fast(A);
mi = ami(L,l);
ri = adjrand(l,L);
results = [results; mi ri t];
[l,t] = unbr_det(A);
mi = ami(L,l);
ri = adjrand(l,L);
results = [results; mi ri t];
[l,t] = unbr_prb_fast(A);
mi = ami(L,l);
ri = adjrand(l,L);
results = [results; mi ri t];
[l,t] = unbr_prb(A);
mi = ami(L,l);
ri = adjrand(l,L);
results = [results; mi ri t];

csvwrite('results.csv',results);