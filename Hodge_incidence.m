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
%   Note: The incidence matrix can be computed using B = PH_boundary(kSkeleton)
%   as well. 
%
% The method is published in
%
% Anand, D.V., Dakurah, S., Wang, B., Chung, M.K. 2021
% Hodge-Laplacian of brain networks and its application to modeling cycles.
% arXiv:2110.14599 https://arxiv.org/pdf/2110.14599.pdf
%
%
%
% (C) 2021 Moo K. Chung, Vijay Anand
%          University of Wisconsin-Madison
%
% Contact mkchung@wisc.edu for the maintainance of codes and support.
%
% Update history
%     2021 November 11, created Vijay Anand
%     2021 December 04, commented Moo Chung
%     2022 November 15, it can handle 2nd boundary matrix now.
%     2024 July 30, error producing line corrected: 
%                   boundaryMatrix1(i, j) = (-1)^mod(omittedIndex + 1, 2);



B = PH_boundary(kSkeleton);

IncidenceMat{2} = B{1};
IncidenceMat{3} = B{2};


function B = PH_boundary(S)
%PH_boundary compute the boundary matrices of a simplicial complex.
%
%   B = PH_boundary(S) computes the boundary matrices of the simplicial
%   complex S represented as a cell array of simplices. The output is a
%   cell array B containing the boundary matrices of the complex in each
%   dimension.
%
%   Inputs:
%       S - cell array containing the simplices of the k-skeletons of a
%           Rips complex. It contains list of nodes that forms the k-simplex.
%
%   Outputs:
%       B - cell array containing the boundary matrices of the simplices in S.
%
% (C) 2023 Moo K. Chung, Universtiy of Wisconsin-Madison 
%
%     Email: mkchung@wisc.edu


% Compute the number of dimensions of the simplicial complex
k = length(S) - 1;

% Initialize the boundary matrices
B = cell(k, 1);
p = size(S{1}, 1);

% Compute the number of simplices in each dimension
num_simplices = zeros(1, k+1);
for d = 0:k
    num_simplices(d+1) = nchoosek(p, d+1);
end

% Compute the boundary matrices for each dimension
for d = 1:k
    % Get the simplices of dimension d and d+1
    simplices_d = S{d};
    simplices_d1 = S{d+1};

    % Compute the boundary matrix for dimension d
    num_simplices_d = size(simplices_d,1);
    num_simplices_d1 = size(simplices_d1,1);
    %boundary = sparse(num_simplices_d, num_simplices_d1);
    boundary = zeros(num_simplices_d, num_simplices_d1);

    for ii = 1:num_simplices_d1
        simplex = simplices_d1(ii, :);
        for jj = 1:d+1
            face = simplex;
            face(jj) = [];
            idx = find(ismember(simplices_d, face, 'rows'));
            if ~isempty(idx)
                boundary(idx, ii) = (-1)^(jj-1);
            end
        end
    end
    B{d} = boundary;
end







%% OLD code cause serious errors for numerious pathological examples.
% 
% nodes=kSkeleton{1};
% edges=kSkeleton{2};
% triangles=kSkeleton{3};
% 
% nedges=size(edges,1);
% nnodes=size(nodes,1);
% ntriangles=size(triangles,1);
% 
% boundaryMatrix1 = zeros(nnodes,nedges);
% 
% % Construct the 1st boundary matrix
% for i = 1:nnodes
%     for j = 1:nedges
% 
%         % If the first node of the edge is greater than the current node, break the loop
%         if edges(j, 1) > nodes(i, 1)
%             break
%         end
% 
%         % If the current node is greater than the second node of the edge, continue to the next iteration
%         if nodes(i, 1) > edges(j, 2)
%             continue
%         end
% 
%         %OLD code producing error for empty indexing
%         % % Check if the node is a member of the edge
%         % if ismembc(nodes(i, :), edges(j, :))
%         %     % Find the omitted index which is not part of the node in the edge
%         %     [~, omittedIndex] = find(ismembc(edges(j, :), nodes(i, :)) == 0);
%         %     % Assign the value to the boundary matrix
%         %     boundaryMatrix1(i, j) = (-1)^mod(omittedIndex + 1, 2);
%         % end
% 
%         % Check if the node is a member of the edge
%             if any(nodes(i, :) == edges(j, 1)) || any(nodes(i, :) == edges(j, 2))
%                 % Determine the orientation
%                 if nodes(i, 1) == edges(j, 1)
%                     boundaryMatrix1(i, j) = -1;
%                 else
%                     boundaryMatrix1(i, j) = 1;
%                 end
%             end
% 
%     end
% end
% IncidenceMat{2} = boundaryMatrix1(:,:);
% 
% boundaryMatrix2 = zeros(nedges,ntriangles);
% for i=1:nedges
%     for j=1:ntriangles
% 
%         if triangles(j,1)>edges(i,1)
%             break
%         end
%         if edges(i,1)>triangles(j,2)
%             continue
%         end
% 
%         %if ismembc(edges(i,:),triangles(j,:))
%         %    [~, omitedIndex] = find(ismembc(triangles(j,:), edges(i,:))==0);
%         %    boundaryMatrix2(i,j)=(-1)^mod(omitedIndex+1,2);
%         %end
% 
%         % Check if the edge is a member of the triangle
%         if any(edges(i, 1) == triangles(j, :)) && any(edges(i, 2) == triangles(j, :))
%             % Determine the orientation
%             [~, omittedIndex] = find(~ismember(triangles(j, :), edges(i, :)));
%             boundaryMatrix2(i, j) = (-1)^mod(omittedIndex + 1, 2);
%         end
% 
% 
%     end
% end
% IncidenceMat{3}=boundaryMatrix2(:,:);
% 
% end
% 

