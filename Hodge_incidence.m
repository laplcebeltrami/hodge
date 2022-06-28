function IncidenceMat=Hodge_incidence(kSkeleton)
%function IncidenceMat=PH_incidence(kSkeleton)
%
%   The function loads the kSkeleton [node edge] and computes the incidence matrix.
%
%   INPUT : k-Skeleton
%   OUTPUT : Incidence Matrix
%
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
%     2021 November 11, created Vijay Anand
%     2021 December 04, commented Moo Chung


    edges=kSkeleton{2};
    nodes=kSkeleton{1};

    nedges=size(edges,1); 
    nnodes=size(nodes,1);

    boundaryMatrix = zeros(nnodes,nedges);

    for i=1:nnodes
        for j=1:nedges
            
            if edges(j,1)>nodes(i,1)
                break
            end
            if nodes(i,2-1)>edges(j,2)
                continue 
            end
            if ismembc(nodes(i,:),edges(j,:))
                [~, omitedIndex] = find(ismembc(edges(j,:), nodes(i,:))==0);
                boundaryMatrix(i,j)=(-1)^mod(omitedIndex+1,2);  
            end   
        end
    end
    IncidenceMat{2}=boundaryMatrix(:,:); 
end