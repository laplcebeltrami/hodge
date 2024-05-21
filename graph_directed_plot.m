function Graph_directed_plot(coord, elist, weights)
% This function plots a directed graph using the given edge list, 
% edge weights, and node coordinates.
%
% INPUTS:
%   coord   - n-by-2 matrix of node coordinates [x, y]
%   elist   - Matrix of edges with two columns: [start_node, end_node]
%   weights - Vector of weights for each edge
%
%
% OUTPUT:
%   A plot of the directed graph

% Extract starting and ending nodes from the edge list
Estart = elist(:, 1);
Eend = elist(:, 2);

% Create a directed graph
G = digraph(Estart, Eend, weights);

% Round edge weights to 3 decimal places for labeling
EWeights = round(G.Edges.Weight, 3);

% Plot the graph with specified layout and properties
p = plot(G, 'Layout', 'force', 'EdgeLabel', EWeights, 'LineWidth', 3, ...
    'NodeColor', [0 0 0], 'MarkerSize', 6, ...
    'NodeFontSize', 14, 'EdgeFontSize', 14);

% Set node coordinates
p.XData = coord(:, 1);
p.YData = coord(:, 2);

% Customize arrow size and edge color
p.ArrowSize = 15;
p.EdgeColor = 'k';

% Customize axes and figure properties
h = gca;
set(h, 'FontSize', 10);
set(gcf, 'Position', [200 200 300 250]);
set(h, 'XTickLabel', []);
set(h, 'YTickLabel', []);
h.XAxis.TickLength = [0 0];
h.YAxis.TickLength = [0 0];

end
