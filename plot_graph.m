function h = plot_graph(G, coord)
% plot_graph(G)
%
% Plot graph in 3D using automatic layout.
%
% INPUT
%   G     : MATLAB graph object
%   coord : (optional) n x 2 or n x 3 node coordinates
%
% OUTPUT
%   h : figure handle
%
% (C) 2026 Moo K. Chung


% Determine coordinates
if nargin < 2 || isempty(coord)
    p = plot(G);
    X = p.XData;
    Y = p.YData;
    Z = zeros(size(X));   
    delete(p);            % remove temporary plot
else
    X = coord(:,1);
    Y = coord(:,2);
    if size(coord,2) == 3
        Z = coord(:,3);
    else
        Z = zeros(size(X));   % embed 2D into 3D
    end
end         % remove default plot  

% --- plot nodes ---
scatter3(X, Y, Z, 100, 'k', 'filled');

hold on;

% --- node labels ---   
for i = 1:length(X)
    text(X(i)+0.05, Y(i)+0.05, Z(i)+0.05, ...
        ['  ' num2str(i)], ...   
        'FontSize', 14, ...
        'Color', [0 0.5 0] );
end

% --- draw edges ---
E = G.Edges.EndNodes;
for i = 1:size(E,1)
    plot3([X(E(i,1)) X(E(i,2))], ...
          [Y(E(i,1)) Y(E(i,2))], ...
          [Z(E(i,1)) Z(E(i,2))], ...
          'k', 'LineWidth', 3);
end

axis equal; 
%set(gca, 'XTick', [], 'YTick', [], 'ZTick', []);   
grid on; axis on

set(gca,'FontSize',12);
set(gcf,'Color','w','InvertHardcopy','off');

end