function [Ims, Kms] =MeanShift_Seg(I,bandwidth,kernel)
%
% MEANSHIFT_SEG - Mean Shift Clustering Segmentation
%   
% SYNTAX
%
%   [IMS KMS] = MEANSHIFT_SEG(I, BANFWIDTH)
%
% INPUT
%
%   I           Point cloud                     [N-by-D]
%   Bandwidth   Bandwidth                       [scalar]
%   
% OUTPUT
%
%   IMS         Point cloud                     [N-by-D]
%   KMS         Number of points in each cluster[scalar]
%
% DESCRIPTION
%
%  [IMS KMS] = MEANSHIFT_SEG(I, BANFWIDTH) using mean shift to do
%  clustering segmentation of an image
%
% DEPENDENCIES
%
%   MEANSHIFTCLUSTER.M
%
%


%% Check input
if nargin < 2
    error('no bandwidth specified')
end

if nargin < 3
    plotFlag = false;
end


%% color + spatial (option: bandwidth)

I = im2double(I);

% Spatial Features
[x,y] = meshgrid(1:size(I,2),1:size(I,1)); L = [y(:)/max(y(:)),x(:)/max(x(:))];

% Color & Spatial Features
C = reshape(I,size(I,1)*size(I,2),3); X = [C,L];                                


%% MeanShift Segmentation

% MeanShiftCluster
[clustCent,point2cluster,clustMembsCell] = MeanShiftCluster(X',bandwidth,kernel);  

% Replace Image Colors With Cluster Centers
for i = 1:length(clustMembsCell)                                                
X(clustMembsCell{i},:) = repmat(clustCent(:,i)',size(clustMembsCell{i},2),1); 
end

% Segmented Image
Ims = reshape(X(:,1:3),size(I,1),size(I,2),3);                                  
Kms = length(clustMembsCell);

end


%%------------------------------------------------------------
%
% AUTHORS
%
%   Zekun Cao       
%
% REVISIONS
% 
%   0.1  (2013) - Alireza Asvadi, Department of ECE, SPR Lab, Babol (Noshirvani) University of Technology
%   0.2 (Fall 2017) - Zekun Cao
% ------------------------------------------------------------
