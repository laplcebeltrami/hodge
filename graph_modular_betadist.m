function adj = graph_modular_betadist(d, c, aa, bb)
% Generate random modular network introduced in 
% Anand, D.V., Das, S., Dakurah, S., Chung, M.K. 2022
% Hodge-Decomposition of Brain Networks. 
%
% INPUT
% d : number of nodes
% c : number of clusters/modules
% aa : alpha parameter for Beta distribution
% bb : beta parameter for Beta distribution
%
% OUTPUT
% adj : randomly weighted adjacency matrix using the Beta distribution
%
%
% %If you are using any part of the code, please reference the above paper.
%
% (C) 2022 Anand, D.V., Chung, M.K. 
%     University of Wisconsin-Madison
%
%  Contact mkchung@wisc.edu for
%  for support/permission with the codes 
%
% Update history
%     April, 2022 created - Vijay Anand D


% adjacency matrix
adj = zeros(d);

% nodes are evenly distributed among modules
modules = cell(c, 1);
for k = 1:c
    modules{k} = round((k-1)*d/c+1):round(k*d/c);
end

for i = 1:d
    for j = i + 1:d
        module_i = ceil(c*i/d); % the module of node i
        module_j = ceil(c*j/d); % the module of node j

        % check if nodes i and j belongs to the same module
        if module_i == module_j
            % edge values for attachment within module
            p = betarnd(aa, bb);
            adj(i, j) = p;
            adj(j, i) = p;
        else
            % edge values for attachment between modules
            q = betarnd(bb, aa);
            adj(i, j) = q;
            adj(j, i) = q;
        end
    end
end

end