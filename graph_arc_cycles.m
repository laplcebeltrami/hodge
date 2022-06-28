function [adj,ncoord] = graph_arc_cycles(mu, sigma, np, type, scalex, scaley, rotate)
%function adj = graph_cycles(mu, sigma, np, type, scalex, scaley, rotate)
%
% Generate random networks with looops and cut an arc. The random network model is
% introduced in
%
% Dakurah, S., Anand, D.V.,Chung, M.K. 2022 
% Modelling Cycles in Brain Networks using Hodge Laplacian
%
%
% INPUT
% mu: the mean of the distrbution(normal) to generate the points
% sigma: the random perturbation term to add to the points
% np: the number of random points to generate
% type: the type of network to generate. The five types are
%       1 => deltroid (1-cycle) 1-loop 
%       2 => Trisectrix (1-cycle) 2-loops 
%       3 => Trifolium (1-cycle) 3-loops 
%       4 => Quadrifolium (1-cycle) 4-loops 
%       6 => Double Trifolium(1-cycle) 6-loops
% scalex: scalar value to increase the x-axis value 
% scaley: scalar value to increase the y-axis value
% rotate: rotate the figure 180 degrees. 1 -> rotate; 0 -> do not rotate
%
% OUTPUT
% adj: the adjacency matrix
% ncoord: the generated cordinate data
%
%
% 
% %If you are using any part of the code, please reference the above paper.
%
% (C) 2022 Sixtus Dakurah
%          University of Wisconsin-Madison
%
%  Contact mkchung@wisc.edu or mkchung@wisc.edu
%  for support/permission with the codes 
%

theta = linspace(0,2*pi,np);

switch type
    case 0
        if rotate
            theta = linspace(0,1.5*pi,np);
            x = scalex + cos(theta) + cos(theta).*cos(theta);
            y = scaley + sin(theta) - sin(theta).*cos(theta);
        else
            theta = linspace(0,1.8*pi,np);
            x = scalex + cos(theta) - cos(theta).*cos(theta);
            y = scaley + sin(theta) + sin(theta).*cos(theta);
        end
    case 1
        arcrate = 15;
        arc = [pi/arcrate   2*pi-pi/arcrate];
        theta = linspace(arc(1),arc(2),np);
        if rotate
            x = scalex + cos(theta) - cos(2*theta);
            y = scaley + sin(theta) - sin(2*theta);
        else
            x = scalex + cos(theta) + cos(2*theta);
            y = scaley + sin(theta) + sin(2*theta);
        end
    case 2
        % generate trisectrix
        arc = [pi/10   2*pi-pi/10];
        theta = linspace(arc(1),arc(2), np);
        x = scalex + cos(theta) + cos(2*theta);
        y = scaley + sin(theta) - sin(2*theta);
    case 3
        % generate trifolium
        arc = [pi/15   2*pi-pi/15];
        theta = linspace(arc(1),arc(2), np);
        x = scalex + cos(theta) + cos(4*theta);
        y = scaley + sin(theta) + sin(4*theta);
    case 4
        % generate quadrifolium
        x = scalex + sin(theta).*cos(2*theta);
        y = scaley + cos(theta).*cos(2*theta);
    case 6
        % generate double trif olium
        x = scalex + 0.2*cos(theta) + cos(theta).*cos(3.1*theta);
        y = scaley + 0.2*sin(theta) + sin(theta).*cos(3.1*theta);
end

coord=[x; y]';
npoints = length(coord);
ncoord = coord + normrnd(mu,sigma,npoints,2);
dmatrix = pdist(ncoord);
C = squareform(dmatrix);
adj=C;
end




