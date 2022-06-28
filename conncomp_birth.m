function birthMtx = conncomp_birth(adj)
% Compute a set of increasing birth values for 0D barcode
%
% INPUT
% adj      : weighted adjacency matrix
%
% OUTPUT
% birthMtx : matrix whose 1st and 2nd columns are end nodes (no duplicates)
%            and 3rd column is weight (in ascending order, i.e., 1st row is
%            smallest)
%
% (C) 2020 Tananun Songdechakraiwut, Moo K. Chung
%          University of Wisconsin-Madison
%
%  Contact tananun@cs.wisc.edu or mkchung@wisc.edu
%  for support/permission with the codes 
%
% Update history:
%     2020 August 11 modified by Tananun from Lee's code
%     2021 May 25    comment by Chung

g = graph(-adj, 'upper', 'omitselfloops'); % minus weights to find max spanning tree
gTree = minspantree(g); % find max spanning tree of -adj
gTreeMtx = gTree.Edges{:, :}; % edge info.
gTreeMtx(:, 3) = gTreeMtx(:, 3) * -1; % reverse back to positive weights
birthMtx = sortrows(gTreeMtx, 3);

end