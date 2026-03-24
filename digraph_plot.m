function coord = digraph_plot(Gdir, coord)
% digraph_plot(Gdir)
%
% Plot a directed graph by first displaying the underlying undirected
% topology and then overlaying dominant directed arrows.
%
% INPUT
%   Gdir : MATLAB digraph object
%   coord : (optional) n x 2 or n x 3 node coordinates
%
% OUTPUT
%   none
%
% (C) 2026 Moo K. Chung
% University of Wisconsin-Madison

% Convert directed graph to adjacency matrix
A = digraph2adj(Gdir);
A_undir = max(abs(A), abs(A')); %do not use abs. 
% It doubles for undirected graph
% Build undirected graph from the absolute adjacency matrix
G = graph(A_undir);


%p = plot(G);        % automatic layout (force-directed by default)
%coord = [p.XData(:), p.YData(:)];   % extracted node coordinates

% Plot graph with or without provided coordinates
if nargin < 2 || isempty(coord)
    p = plot(G);                             % automatic layout
    coord = [p.XData(:), p.YData(:)];        % extracted coordinates
else
    if size(coord,2) == 2
        p = plot(G,'XData',coord(:,1),'YData',coord(:,2));  % use given 2D coords
    end
end

% Plot undirected topology (assumes plot_graph uses current axes)
plot_graph(G,coord);
hold on;

% Overlay dominant directed arrows
graph_add_arrows(Gdir,coord);
end
