function Yvec = Hodge_vec(adj)
%function Yvec = Hodge_vec(adj)

% This function vectorizes the upper triangle of an adjacency matrix.
%
% INPUT:
%   adj - Upper triangle connectivity matrix (n x n)
%
% OUTPUT:
%   Yvec - Vectorized connectivity matrix (vector of edge weights)
%
% Create 0-Skeleton
%
% (C) 2024 Vijay Anand, Moo K. Chung
% University of Wisconsin-Madison
% mkchung@wisc.edu for code maintenance and support.

n = length(adj); % Number of nodes

% List of nodes (0-Skeleton)
nlist = [];
for i = 1:n
    nlist = [nlist; i];
end

% Create 1-Skeleton (nodes and edges)
adj1 = abs(adj); % Ensure adjacency matrix is non-negative
edges = find(triu(adj1 > 0)); % Indices of all edges in the upper triangle

elist = [];
for e = 1:length(edges)
    [i, j] = ind2sub([n, n], edges(e)); % Node indices of edge e
    elist = [elist; i j adj(i, j)]; % List of edges with their weights
end

% Sort edges by the first node
elist = sortrows(elist, 1);

% Extract edge weights
Yvec = elist(:, 3);
end
