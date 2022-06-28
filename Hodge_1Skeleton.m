function kSkeleton = Hodge_1Skeleton(adj)
%function kSkeleton = Hodge_1Skeleton(adj)
%
% This function takes an adjacency matrix of a tree and construct a 1-skeleton
%
% INPUT
%   adj: binary adjacency matrix
%
% OUTPUT
%   kSkeleton: 1-Skeleton with node and edge list
%
% The method is published in
%
% Anand, D.V., Dakurah, S., Wang, B., Chung, M.K. 2021
% Hodge-Laplacian of brain networks and its application to modeling cycles.
% arXiv:2110.14599 https://arxiv.org/pdf/2110.14599.pdf
%
%
%
%    
%
% (C) 2021 Vijay Anand, Moo K. Chung
%          University of Wisconsin-Madison
%
% Contact mkchung@wisc.edu for the maintainance of codes and support.  
%
% Update history
%     2021 November 11, created Vijay Anand
%     2021 December 04, commented Moo Chung

n = length(adj); % number of nodes

nlist = [];
for i = 1:n
    nlist = [nlist; i ];
end
kSkeleton{1} = nlist;

edges = find(triu(adj>0)); % indices of all edges
elist = [];
for e = 1:length(edges)
    [i,j] = ind2sub([n,n],edges(e)); % node indices of edge e
    elist = [elist; i j adj(i,j)];
end
elist = sortrows(elist,1);
kSkeleton{2} = elist(:,1:2);
