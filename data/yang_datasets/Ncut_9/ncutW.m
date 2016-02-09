function [NcutDiscrete,NcutEigenvectors,NcutEigenvalues] = ncutW(W,nbcluster, nSeed)
% [NcutDiscrete,NcutEigenvectors,NcutEigenvalues] = ncutW(W,nbcluster);
% 
% Calls ncut to compute NcutEigenvectors and NcutEigenvalues of W with nbcluster clusters
% Then calls discretisation to discretize the NcutEigenvectors into NcutDiscrete
% Timothee Cour, Stella Yu, Jianbo Shi, 2004

if ~exist('nSeed','var') || isempty(nSeed)
    nSeed = 0;
end

% compute continuous Ncut eigenvectors
[NcutEigenvectors,NcutEigenvalues] = ncut(W,nbcluster);

% compute discretize Ncut vectors
[NcutDiscrete,NcutEigenvectors] =discretisation(NcutEigenvectors, nSeed);


NcutDiscrete = full(NcutDiscrete);