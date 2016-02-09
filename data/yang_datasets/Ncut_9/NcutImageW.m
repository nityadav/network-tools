function [SegLabel,NcutDiscrete,NcutEigenvectors,NcutEigenvalues,W]= NcutImageW(I,W,nbSegments)
%  [SegLabel,NcutDiscrete,NcutEigenvectors,NcutEigenvalues,W,imageEdges]= NcutImage(I);
%  Input: I = brightness image
%         nbSegments = number of segmentation desired
%  Output: SegLable = label map of the segmented image
%          NcutDiscrete = Discretized Ncut vectors
%  
% Timothee Cour, Stella Yu, Jianbo Shi, 2004.
% Modified by Zhirong Yang, 2011, to accommodate other calculation of W


 
if ~exist('nbSegments', 'var') || isempty(nbSegments)
   nbSegments = 10;
end

if ~exist('W', 'var') || isempty(W)
    W = ICgraph(I);
end

[NcutDiscrete,NcutEigenvectors,NcutEigenvalues] = ncutW(W,nbSegments);

%% generate segmentation label map
[nr,nc,nb] = size(I);

SegLabel = zeros(nr,nc);
for j=1:size(NcutDiscrete,2),
    SegLabel = SegLabel + j*reshape(NcutDiscrete(:,j),nr,nc);
end