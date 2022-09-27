function [adj,ncoord] = graph_loops(k, sigma,theta)
%function [adj,ncoord] = graph_loops(k, sigma,theta)
%
% Generate random networks with looops. The random network model is
% introduced in
%
% Anand, D.V., Dakurah, S., Wang, B., Chung, M.K. 2021 
% Hodge-Laplacian of brain networks and its application to modeling cycles.
% arXiv:2110.14599 https://arxiv.org/pdf/2110.14599.pdf
%
% (C) 2021 Vijay Anand, Moo K. Chung
%          University of Wisconsin-Madison
%
% Contact mkchung@wisc.edu for the maintainance of codes and support.  
%
% Update history
%     2021 November 11, created Vijay Anand
%     2021 November 25, edited Moo Chung


switch k
    case 1 %1 loop = circle
        x=cos(theta);
        y=sin(theta);
    case 2 % 2 loops = figure-8
        x = sin(pi*theta/2);
        y = sin(pi*theta);
    case 4 % 4 loops = clover
        x=sin(theta).*cos(2*theta);
        y=cos(theta).*cos(2*theta);
end


coord=[x; y]';
npoints = length(coord);
%Euclidean distance matrix to feed into graph filtration
ncoord = coord + normrnd(0,sigma,npoints,2);

%transform coordinate data into Euclidean distance matrix
dmatrix = pdist(ncoord);
C = squareform(dmatrix);
adj=C;





