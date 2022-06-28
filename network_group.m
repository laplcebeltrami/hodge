function [g1, g11] = network_group(nGroup, type)
%[g1, g11] = network_group(nGroup, type)
%
% Simulate the network group
%
% Dakurah, S., Anand, D.V.,Chung, M.K. 2022 
% Modelling Cycles in Brain Networks using Hodge Laplacian
%
%
% INPUT
% nGroup: number of networks to simulate in the group
% type: the network group type: [1 2 3 4]
%
% OUTPUT
% g1: the cell of collection of the group networks
% g11: the cell of collection of the geometric cordinates
% 
% %If you are using any part of the code, please reference the above paper.
%
% (C) 2022 Sixtus Dakurah
%          University of Wisconsin-Madison
%
%  Contact mkchung@wisc.edu or mkchung@wisc.edu
%  for support/permission with the codes 
%
mu = 0;
sigma = 0.025;
np=50;

switch type
    case 1
        for i=1:nGroup
            % Group code
            [adj1, coord1] = graph_cycles(mu, sigma, np, 1, 0.5, 0, false);
            [adj2, coord2] = graph_cycles(mu, sigma, np, 2, 0.0, 0, false);
            adj = [adj1 adj2];
            coord = [coord1 coord2];
            C = pdist(adj);
            g1{i} = squareform(C);
            g11{i} = coord;
        end
    case 2
        for i=1:nGroup
            % Group code
            [adj1, coord1] = graph_cycles(mu, sigma, np, 1, -1, 0, false);
            [adj2, coord2] = graph_cycles(mu, sigma, np, 2, 0, 0, false);
            adj = [adj1 adj2];
            coord = [coord1 coord2];
            C = pdist(adj);
            g1{i} = squareform(C);
            g11{i} = coord;
        end
    case 3
        for i=1:nGroup
            % Group code
            [adj1, coord1] = graph_cycles(mu, sigma, np, 3, 1, 0, false);
            [adj2, coord2] = graph_arc_cycles(mu, sigma, np, 2, 1, 0, true);
            adj = [adj1 adj2];
            coord = [coord1 coord2];
            C = pdist(adj);
            g1{i} = squareform(C);
            g11{i} = coord;
        end
    case 4
        for i=1:nGroup
            % Group code
            [adj1, coord1] = graph_cycles(mu, sigma, np, 3, 1, 0, true);
            [adj2, coord2] = graph_arc_cycles(mu, sigma, np, 2, 1, 0, true);
            adj = [adj1 adj2];
            coord = [coord1 coord2];
            C = pdist(adj);
            g1{i} = squareform(C);
            g11{i} = coord;
        end
end

end