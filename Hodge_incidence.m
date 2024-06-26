function IncidenceMat=Hodge_incidence(kSkeleton)
%function IncidenceMat=PH_incidence(kSkeleton)
%
%   The function loads the kSkeleton [node edge] and computes the incidence matrix.
%
%   INPUT 
%   kSkeleton = k-Skeleton
%
%   OUTPUT : 
%   IncidenceMat = Incidence Matrix
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
%     2022 November 15, it can handle 2nd boundary matrix now.

nodes=kSkeleton{1};
edges=kSkeleton{2};
triangles=kSkeleton{3};

nedges=size(edges,1);
nnodes=size(nodes,1);
ntriangles=size(triangles,1);

boundaryMatrix1 = zeros(nnodes,nedges);
for i=1:nnodes
    for j=1:nedges

        if edges(j,1)>nodes(i,1)
            break
        end
        if nodes(i,1)>edges(j,2)
            continue
        end
        if ismembc(nodes(i,:),edges(j,:))
            [~, omitedIndex] = find(ismembc(edges(j,:), nodes(i,:))==0);
            boundaryMatrix1(i,j)=(-1)^mod(omitedIndex+1,2);
        end
    end
end
IncidenceMat{2}=boundaryMatrix1(:,:);



boundaryMatrix2 = zeros(nedges,ntriangles);
for i=1:nedges
    for j=1:ntriangles

        if triangles(j,1)>edges(i,1)
            break
        end
        if edges(i,1)>triangles(j,2)
            continue
        end
        if ismembc(edges(i,:),triangles(j,:))
            [~, omitedIndex] = find(ismembc(triangles(j,:), edges(i,:))==0);
            boundaryMatrix2(i,j)=(-1)^mod(omitedIndex+1,2);
        end
    end
end
IncidenceMat{3}=boundaryMatrix2(:,:);

end

%     edges=kSkeleton{2};
%     nodes=kSkeleton{1};
%
%     nedges=size(edges,1);
%     nnodes=size(nodes,1);
%
%     boundaryMatrix = zeros(nnodes,nedges);
%
%     for i=1:nnodes
%         for j=1:nedges
%
%             if edges(j,1)>nodes(i,1)
%                 break
%             end
%             if nodes(i,2-1)>edges(j,2)
%                 continue
%             end
%             if ismembc(nodes(i,:),edges(j,:))
%                 [~, omitedIndex] = find(ismembc(edges(j,:), nodes(i,:))==0);
%                 boundaryMatrix(i,j)=(-1)^mod(omitedIndex+1,2);
%             end
%         end
%     end
%     IncidenceMat{2}=boundaryMatrix(:,:);
% end