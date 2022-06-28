function plot_network_group(gkk, type)
%function plot_cycle(g11, g22, type1, type2)
%
% Make a plot of the simulated networks given the geometric cordinates
%
% Dakurah, S., Anand, D.V.,Chung, M.K. 2022 
% Modelling Cycles in Brain Networks using Hodge Laplacian
%
%
% INPUT
% g11: cell collection of type1 (group) networks
% g22: cell collection of type2 (group) networks
% type1: the group of networks in g11
% type2: the group of networks in g22
%
% OUTPUT
% Returns a plot
%
% %If you are using any part of the code, please reference the above paper.
%
% (C) 2022 Sixtus Dakurah
%          University of Wisconsin-Madison
%
%  Contact mkchung@wisc.edu or mkchung@wisc.edu
%  for support/permission with the codes 
%
    %-------- Make the group plots
    for ii = 1:length(gkk)
        coord = gkk{ii};
        coord1 = coord(:, 1:2);
        coord2 = coord(:, 3:4);
        % Make the plot
        plot(coord1(:,1),coord1(:,2),'.k')
        hold on;
        plot(coord2(:,1),coord2(:,2),'.k')
        hold on;
    end
    plot(coord1(:,1),coord1(:,2),"Color", 'k')
    hold on;
    plot(coord2(:,1),coord2(:,2),"Color", 'k')
    axis square
    figure_bigger(16)
    title(strcat("Group ", string(type)))

end