function W = weightedNeighborGraph_SPARSE (X,C, epsilon,S)
%
% WEIGHTEDNEIGHBORGRAPH_SPARSE - Similarity Graph
%                                (Seuclidean ball neighborhoods) 
%   
% SYNTAX
%
%   W = WEIGHTEDNEIGHBORGRAPH_SPARSE( X,C,EPSILON, S )
%
% INPUT
%
%   X           Point cloud                     [N-by-D]
%   C           Point cloud                     [N-by-D]
%   EPSILON     Euclidean ball radius           [scalar]
%   S           Scale Parameter                 [N-by-One]
%   
% OUTPUT
%
%   W           Sparse Similarity Graph adjacency     [N-by-N]
%               matrix with zeros when ||X-X||>EPSILON
%
% DESCRIPTION
%
%   W = WEIGHTEDNEIGHBORGRAPH(X,C,EPSILON, S) computes the weighted
%   EPSILON-radius Seuclidean-ball similar neighborhood graph among all points in X and C.
%
% DEPENDENCIES
%
%   [Statistics and Machine Learning Toolbox]
%
%
% See also      knnsearch, rangesearch
%
    
    
    % find indices and distances of all epsilon-neighbors for each point in X
    A = [C X]; 
    n = size( A, 1 );
    [idxTgt, D] = rangesearch( A, A, epsilon, 'Distance', 'seuclidean', 'Scale', S);
    
    % reshape the results into the vector of a sparse matrix
    % ivec - rows; jvect - columns; sevec - values
    
    ivec = cell2mat(idxTgt');
    jvec = cell2mat(cellfun( @(X,isrc) isrc * ones( 1, length(X) ), ...
                       idxTgt', num2cell(1:n), 'UniformOutput', false ));
    svec = cell2mat(D');
    
    % form the sparse matrix from the vectors
    
    W = sparse(ivec, jvec, svec, n, n);
    
end

%%------------------------------------------------------------
%
% AUTHORS
%
%   Zekun Cao
%
% REVISIONS
%
%   0.1 (Spring 2017) - Alexandros
%   0.2 (Fall 2017) - Zekun Cao
% ------------------------------------------------------------
