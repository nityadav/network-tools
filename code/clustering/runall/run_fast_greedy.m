A = csvread('../data/adj.csv');
cd ../fast_greedy/
tic
l = fast_newman(A)
toc