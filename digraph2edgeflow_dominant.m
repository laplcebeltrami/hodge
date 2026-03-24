function flows = digraph2edgeflow_dominant(G)
% digraph2edgeflow_dominant  Extract dominant directed edge flows from a digraph.
%
% INPUT
%   G : digraph object in MATLAB format
%
% OUTPUT
%   flows : r x 3 array [u v w]
%           u -> v is the dominant direction
%           w >= 0 is the dominant flow magnitude
%
% For each unordered node pair {i,j}, the function combines the two
% directed edges i->j and j->i into a single dominant directed flow.
%
% (C) 2026 Moo K. Chung
% University of Wisconsin-Madison

A = full(adjacency(G, 'weighted'));
n = size(A,1);

flows = [];

for i = 1:n
    for j = i+1:n

        wij = A(i,j);
        wji = A(j,i);

        % net dominant flow
        w = wij - wji;

        if abs(w) < 1e-12
            continue
        end

        if w > 0
            u = i;
            v = j;
            mag = w;
        else
            u = j;
            v = i;
            mag = -w;
        end

        flows = [flows; u v mag]; %#ok<AGROW>
    end
end

end