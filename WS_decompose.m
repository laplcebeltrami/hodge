function [Wb Wd] = WS_decompose(W)
%[Wb, Wd] = WS_decompose(W)
%    
% Performs the birth-death decomposition of edge sets.
%
% INPUT
% W : edge weight matrix. weighted adjacency martrix
%
% OUTPUT
% Wb : birth edge set     (p-1) x 3 x n, where p is # of nodes, n is # of subjects
% Wd : death edge set     (p-1)*(p-2)/2 x 3 x n
%
%
% The method is published in
% 
% [1] Songdechakraiwut, T., Shen, L., Chung, M.K. 2021 Topological learning and 
%its application to multimodal brain network integration, Medical Image 
%Computing and Computer Assisted Intervention (MICCAI), LNCS 12902:166-176 
%
% [2] Songdechakraiwut, T. Chung, M.K. 2020 Topological learning for brain 
% networks, arXiv: 2012.00675. 
% 
% [3] Anand, D.V., Dakurah, S., Wang, B., Chung, M.K. 2021 Hodge-Laplacian 
% of brain networks and its application to modeling cycles. arXiv:2110.14599
%
% If you are using any part of the code, please reference the above paper.
% The function is downloaded from 
% http://pages.stat.wisc.edu/~mchung/publication.html
%
%
% (C) 2020 Moo K. Chung
%     University of Wisconsin-Madison
%  Contact mkchung@wisc.edu for support 
%
% Update history
%   2020 May 23 created. Modified from codes written by Song and Lee
%   2021 Nov 28 additional documentation


%% Compute set of births and set of deaths

G1 = graph(W, 'upper', 'omitselfloops');

% birth edge set
birthMtx1 = conncomp_birth(W);
Wb=birthMtx1;

% death edge set
deathMtx1 = rmedge(G1, birthMtx1(:, 1), birthMtx1(:, 2)).Edges{:, :};
% sorting by weights in ascending order
%deathMtx1 = sortrows(deathMtx1, 3, 'descend');
deathMtx1 = sortrows(deathMtx1, 3);
Wd=deathMtx1;

