function pSkeleton = Hodge_2Skeleton(adj)
%function pSkeleton = Hodge_2Skeleton(adj)
%
% This function takes an adjacency matrix and construct a 2-skeleton
%
% INPUT
%   adj: binary adjacency matrix
%
% OUTPUT
%   pSkeleton: 2-Skeleton with node and edge list
%
% The method is published in
%
% Anand, D.V., Dakurah, S., Wang, B., Chung, M.K. 2021
% Hodge-Laplacian of brain networks and its application to modeling cycles.
% arXiv:2110.14599 https://arxiv.org/pdf/2110.14599.pdf
%
%
% (C) 2021 Vijay Anand, Moo K. Chung
%          University of Wisconsin-Madison
%
% Contact mkchung@wisc.edu for the maintainance of codes and support.  
%
% Update history
%     2021 November 11, created Anand
%     2021 December 04, commented Chung
%     2022 November 15, commented Chung
 
    % Create 0-Skeleton
    n = length(adj); % number of nodes
    nlist = [];
    for i = 1:n
        nlist = [nlist; i ];
    end
    pSkeleton{1} = nlist;
    
    % Create 1-Skeleton (nodes and edges)
    adj1=abs(adj);
    edges = find(triu(adj1>0)); % indices of all edges
    elist = [];
    for e = 1:length(edges)
        [i,j] = ind2sub([n,n],edges(e)); % node indices of edge e  
        elist = [elist; i j adj(i,j)];
    end
    elist = sortrows(elist,1);
    pSkeleton{2} = elist(:,1:2);
	
	% Create 2-Skeleton (nodes edges triangles)
    threshold = 0;
    adjnew = adj2bin(adj1,threshold);
    GA = full(adjnew);
    G = tril(GA);
    
	tlistCnt = 1;
    tlist = [];
    nSimplices = size(pSkeleton{2},1);
    for t = 1:nSimplices
        cols = G(:,pSkeleton{2}(t,:));     
        val = all(cols==1,2); 
        edjtotri = pSkeleton{1}(val);
        if ~isempty(edjtotri) 
            for v = 1:length(edjtotri)
                tlist(tlistCnt ,:) = sort([pSkeleton{2}(t,:) edjtotri(v)]) ;
                tlistCnt=tlistCnt+1;
            end
        end
    end
    if isempty(tlist)
        pSkeleton{3}=[];
    end        
    pSkeleton{3} = unique(tlist,'rows');  
end