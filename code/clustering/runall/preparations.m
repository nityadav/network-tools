A = csvread('data/lfr_200_2/adj.csv');
cd ../../converters
adj2pajek(A,'adj','./../clustering/runall/data/lfr_200_2/');
cd ../clustering/runall

A = csvread('data/lfr_200_3/adj.csv');
cd ../../converters
adj2pajek(A,'adj','./../clustering/runall/data/lfr_200_3/');
cd ../clustering/runall

A = csvread('data/lfr_200_4/adj.csv');
cd ../../converters
adj2pajek(A,'adj','./../clustering/runall/data/lfr_200_4/');
cd ../clustering/runall

A = csvread('data/lfr_500_2/adj.csv');
cd ../../converters
adj2pajek(A,'adj','./../clustering/runall/data/lfr_500_2/');
cd ../clustering/runall

A = csvread('data/lfr_500_3/adj.csv');
cd ../../converters
adj2pajek(A,'adj','./../clustering/runall/data/lfr_500_3/');
cd ../clustering/runall

A = csvread('data/lfr_500_4/adj.csv');
cd ../../converters
adj2pajek(A,'adj','./../clustering/runall/data/lfr_500_4/');
cd ../clustering/runall

A = csvread('data/lfr_1000_2/adj.csv');
cd ../../converters
adj2pajek(A,'adj','./../clustering/runall/data/lfr_1000_2/');
cd ../clustering/runall

A = csvread('data/lfr_1000_3/adj.csv');
cd ../../converters
adj2pajek(A,'adj','./../clustering/runall/data/lfr_1000_3/');
cd ../clustering/runall

A = csvread('data/lfr_1000_4/adj.csv');
cd ../../converters
adj2pajek(A,'adj','./../clustering/runall/data/lfr_1000_4/');
cd ../clustering/runall

A = csvread('data/lfr_5000_2/adj.csv');
cd ../../converters
adj2pajek(A,'adj','./../clustering/runall/data/lfr_5000_2/');
cd ../clustering/runall

A = csvread('data/lfr_5000_3/adj.csv');
cd ../../converters
adj2pajek(A,'adj','./../clustering/runall/data/lfr_5000_3/');
cd ../clustering/runall

A = csvread('data/lfr_5000_4/adj.csv');
cd ../../converters
adj2pajek(A,'adj','./../clustering/runall/data/lfr_5000_4/');
cd ../clustering/runall
clear