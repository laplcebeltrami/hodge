function dist = dist_L2(x, y)
% function dist = dist_L1(x, y) 
% Compute the L2 norm between vectorized networks x  and y
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

dist = norm(mean(x) - mean(y), 2);
end