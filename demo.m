%
% SCRIPT: demo.m
%
%
% Demo script for grpah segmenataion.
%
% Embedding method : to be specified 
%
%
% Dependencies
% ============
%
% weightedNeighborGraph_SPARSE.m
% 
%
% References
% ==========
%
% Berkeley BSDS500.
%
%



%% CLEAN UP
clc
clear variables
close all


%% PARAMETERS

% ball radius for similarity graph formation

n = [];
nn = [];
epsilonNbrGraph = 4;
sigma_c = 0.02;


% mean shift Bandwidth
bandwidth   = 0.2;                

%% (BEGIN)

fprintf( '\n***** BEGIN (%s) *****\n\n', mfilename )

if isempty( n )
    n = input( '> Smaples for demo (1: Regualr figure; 2: Compressed figure (faster) ): ' );
    fprintf( '\n' )
end

%% 1. Image Reading

if n ==1
    img1 = imread('11.jpg');
end

if n ==2
    img1 = imread('22.jpg');
end
img1= im2double(img1);
img = sparse(img1(:,:,1));
[m,n] = size(img);


%% 2. Spatial Coordiante Matrx
% 
fprintf( '\n ... generating spatial coordinate vector ... ' )

i = zeros(m*n,2);
for j = 1:n
    for k = 1:m
        i(m*(j-1)+k,1)=k;
        i(m*(j-1)+k,2)=j;
    end
end


%% 3. Pixel and distance Matrx

fprintf( '\n ... generating pixel vector ... ' )

ii = zeros(m*n,3);
ii(:,1)=reshape(img1(:,:,1),[],1);
ii(:,2)=reshape(img1(:,:,2),[],1);
ii(:,3)=reshape(img1(:,:,3),[],1);


%% 4. Similarity Graph

S =[sigma_c sigma_c sigma_c epsilonNbrGraph epsilonNbrGraph];

fprintf( '\n ... generating similarity matrix ... ' )
fprintf( '\n      neighborhood ball radius: %f,  pixel matrix ball radius: %f, threshold: e^-25 \n', epsilonNbrGraph, sigma_c)
tic
W = weightedNeighborGraph_SPARSE (i, ii, 5, S);

sij = -W.^2;
simMatrix =sij;
simMatrix(simMatrix~=0)=exp(simMatrix(simMatrix~=0));
toc

%% 5. Laplacian Matrix

fprintf( '\n ... generating Laplacian Matrix ...\n ' )
tic
G = graph(simMatrix);

L=laplacian(G);

if(issymmetric(L))
[V,D] = eigs(L,7,'sa'); 
else
[V,D] = eigs((L+L')/2,7,'sa');
end
toc

%% Mean Shift

fprintf( '\n ... beginning Mean Shift Segmentation ...\n ' )

if isempty( nn )
    nn = input( '> kernel for meanshift (1: Flat; 2: Gaussian ): ' );
    fprintf( '\n' )
end

if nn == 1
    kernel = 'flat';
elseif nn == 2
    kernel = 'gaussian';
else
    fprintf ('\n ...wrong input ...\n')
    return
end   
tic
[Ims, Kms] = MeanShift_Seg(img1,bandwidth,kernel);
toc


for i = 2:2:7

    XX1 = reshape (V(:,i),m,n);
    Xi = 20*XX1;
    img2(:,:,1)=img1(:,:,1)+Xi;
    img2(:,:,3)=img1(:,:,3)+Xi;
    img2(:,:,2)=img1(:,:,2)+Xi;
    
    figure
  
    imshow( img2 )
    imwrite(img2, ['X' num2str(i) '.jpg']);

    title( ['EigenVector in Image Scale: X' num2str(i)] )
    if i ==2
        imwrite(Xi,'X2Eigenvector.jpg');
    end
    
end




figure

spy( simMatrix )
axis image
title( {'Similarity Graph'} )


figure

imshow(Ims); 
title('MeanShift');
imwrite(Ims, 'MeanShift.jpg');


%%------------------------------------------------------------
%
% AUTHORS
%
%   Alexandros-Stavros Iliopoulos       ailiop@cs.duke.edu
%
% REVISIONS
%
%   0.1 (Spring 2017) - Alexandros
%   0.2 (Fall 2017) - Zekun Cao
% ------------------------------------------------------------
