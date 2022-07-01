function dist = dist_GH(x, y)
% function dist = dist_L1(x, y) 
% Compute the GH distance between vectorized networks x  and y
% INPUT
% x: a matrix of vectorized networks in group1: nGroup1 \times nEdges
% y: a matrix of vectorized networks in group2: nGroup2 \times nEdges
%
% OUTPUT:
% dist: the distance between the networks in the groups
%
% (C) 2022 Sixtus Dakurah,Zijian Chen, Moo K. Chung
%          University of Wisconsin-Madison
%
% Contact mkchung@wisc.edu 
% for any inquary about the code. The code is downloaded from
%https://github.com/laplcebeltrami/hodge

x_vec = mean(x);
y_vec = mean(y);

dist = max(max(PH_SLM(squareform(x_vec)) - PH_SLM(squareform(y_vec))));
end