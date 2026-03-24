function PH_rips_display(X, S)
%   PH_rips_display(X, S) displays the simplicial complex defined 
%   by the vertex coordinates X and the simplices in the cell array S. 
%   The function plots the vertices as black dots in 3D, and the edges 
%   as black lines.
%
%   Inputs:
%       X - a p x d matrix of coordinates of scatter points in R^d
%       S - a cell array containing the simplices of the simplicial 
%           complex
%
%   Outputs:
%       Yellow: 2-simplices, blue: 3-simplices 
%
% Compute the dimension of the simplicial complex
%
%
% (C) 2023 Moo K. Chung, Universtiy of Wisconsin-Madison 
%
%     Email: mkchung@wisc.edu


k = length(S) - 1;

% Ensure X is 3D  
if size(X,2) == 2
    X = [X, zeros(size(X,1),1)];
end
% Create a 3D scatter plot of the vertices
figure;
scatter3(X(:,1), X(:,2), X(:,3), 30, 'k', 'filled');
hold on;

% Plot the edges in the simplicial complex
if k>=1
    if ~isempty(S{2})
        edges = S{2};
        num_edges = size(edges, 1);
        for ii = 1:num_edges
            edge_vertices = edges(ii,:);
            plot3(X(edge_vertices,1), X(edge_vertices,2), X(edge_vertices,3), 'k', 'LineWidth', 1.5);
        end
    end
end


% Keep track of which faces have been plotted
plotted_faces = [];

if k >= 3
    if ~isempty(S{4})
        tetrahedra = S{4};
        num_tetrahedra = size(tetrahedra, 1);
        for ii = 1:num_tetrahedra
            tetrahedron_vertices = tetrahedra(ii,:); %indices for 4 vertices

            % plot face 1: vertices 1, 2, 3
            patch(X(tetrahedron_vertices([1 2 3]), 1), X(tetrahedron_vertices([1 2 3]), 2), X(tetrahedron_vertices([1 2 3]), 3), 'b', 'FaceAlpha', 0.3);
            plotted_faces = [plotted_faces; sort(tetrahedron_vertices([1 2 3]))];

            % plot face 2: vertices 1, 2, 4
            patch(X(tetrahedron_vertices([1 2 4]), 1), X(tetrahedron_vertices([1 2 4]), 2), X(tetrahedron_vertices([1 2 4]), 3), 'b', 'FaceAlpha', 0.3);
            plotted_faces = [plotted_faces; sort(tetrahedron_vertices([1 2 4]))];

            % plot face 3: vertices 1, 3, 4
            patch(X(tetrahedron_vertices([1 3 4]), 1), X(tetrahedron_vertices([1 3 4]), 2), X(tetrahedron_vertices([1 3 4]), 3), 'b', 'FaceAlpha', 0.3);
            plotted_faces = [plotted_faces; sort(tetrahedron_vertices([1 3 4]))];

            % plot face 4: vertices 2, 3, 4
            patch(X(tetrahedron_vertices([2 3 4]), 1), X(tetrahedron_vertices([2 3 4]), 2), X(tetrahedron_vertices([2 3 4]), 3), 'b', 'FaceAlpha', 0.3);
            plotted_faces = [plotted_faces; sort(tetrahedron_vertices([2 3 4]))];
        end
    end
end


% Plot the 2-simplices in the simplicial complex

if k >=2
    if ~isempty(S{3})
        triangles = S{3};
        num_triangles = size(triangles, 1);
        for ii = 1:num_triangles
            triangle_vertices = triangles(ii,:);
            if isempty(plotted_faces) %if there is no plottedface, simply display
                patch(X(triangle_vertices,1), X(triangle_vertices,2), X(triangle_vertices,3), 'y', 'FaceAlpha', 0.5);
            else
                if ~ismember(triangle_vertices, plotted_faces, 'rows') %do not color face that is alrady colored
                    patch(X(triangle_vertices,1), X(triangle_vertices,2), X(triangle_vertices,3), 'y', 'FaceAlpha', 0.5);
                end
            end

        end
    end
end



% Set plot properties
axis equal;
box on;
grid on;
view(3);
%title(['Rips complex up to ' num2str(k) '-simpices']);

set(gca, 'Fontsize',18);
set(gcf,'Color','w','InvertHardcopy','off');