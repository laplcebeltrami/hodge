function Graph_directed_plot(coord, elist, weights)
% Graph_directed_plot  Plot a directed graph with given node coordinates,
% edge list, and edge weights.
%
% INPUTS
%   coord   : n-by-2 node coordinates [x y]
%   elist   : m-by-2 edges [u v] (1-based node indices)
%   weights : m-by-1 edge weights (real, non-sparse). If empty or wrong
%             length, defaults to ones(m,1).
%
% OUTPUT
%   A plotted directed graph.

% -------- sanitize & validate inputs --------
if nargin < 3, weights = []; end
if ~isnumeric(coord) || size(coord,2) ~= 2
    error('coord must be n-by-2 numeric array of [x y] positions.');
end
if ~isnumeric(elist) || size(elist,2) ~= 2
    error('elist must be m-by-2 numeric array of [u v] indices.');
end

% Ensure types/shapes that digraph accepts
elist   = full(double(elist));
Estart  = elist(:,1);
Eend    = elist(:,2);

m = size(elist,1);
n = size(coord,1);

% Basic index checks
if any(Estart < 1 | Estart > n | Eend < 1 | Eend > n | isnan(Estart) | isnan(Eend))
    error('elist contains invalid node indices (must be integers in [1..size(coord,1)]).');
end

% Weights: make real, full, double column; default to ones if empty/mismatch
if isempty(weights)
    weights = ones(m,1);
else
    weights = full(double(weights(:)));
    if numel(weights) ~= m
        warning('weights has length %d but elist has %d rows; using ones.', numel(weights), m);
        weights = ones(m,1);
    end
    if ~isreal(weights)
        warning('weights is complex; using real(weights).');
        weights = real(weights);
    end
    if any(isnan(weights) | isinf(weights))
        warning('weights contains NaN/Inf; replacing with zeros.');
        bad = isnan(weights) | isinf(weights);
        weights(bad) = 0;
    end
end

% -------- build digraph --------
G = digraph(Estart, Eend, weights);

% Labels rounded for readability
EWeights = round(G.Edges.Weight, 3);

% -------- plot --------
p = plot(G, ...
    'Layout', 'force', ...         % initial layout (will be overwritten by coords)
    'EdgeLabel', EWeights, ...
    'LineWidth', 3, ...
    'NodeColor', [0 0 0], ...
    'MarkerSize', 6, ...
    'NodeFontSize', 14, ...
    'EdgeFontSize', 14);

% Set node coordinates
p.XData = coord(:,1);
p.YData = coord(:,2);

% Arrow/edge style
p.ArrowSize = 15;
p.EdgeColor = 'k';

% Axes cosmetics
ax = gca;
set(ax, 'FontSize', 10, 'XTick', [], 'YTick', []);
ax.XAxis.TickLength = [0 0];
ax.YAxis.TickLength = [0 0];
set(gcf, 'Position', [200 200 300 250]);
end

