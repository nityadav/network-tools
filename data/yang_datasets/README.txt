This package contains the experiment codes and datasets used in our ICML2012 work.

The main script to run the experiments is clustering_test.m.

You may need to re-compile the C codes by

mex -largeArrayDims sp_factor.c
mex -largeArrayDims sp_factor_ratio.c

The Normalized Cut and 1-Spectral codes that were used in the experiments are included for repetition purpose. If you want their updated implementations, please visit

http://www.timotheecour.com/software/ncut/ncut.html
http://www.ml.uni-saarland.de/code/oneSpectralClustering/oneSpectralClustering.html



If you use our NMFR codes in our publication, please cite the following paper:

Zhirong Yang, Tele Hao, Onur Dikmen, Xi Chen, Erkki Oja. Clustering by Nonnegative Matrix Factorization Using Graph Random Walk. In Advances in Neural Information Processing Systems 25 (NIPS 2012), Lake Tahoe, USA, 2012.


Zhirong Yang (1-October-2012)
