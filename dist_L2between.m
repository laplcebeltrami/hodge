function dist = dist_L2betweeen(x, y)
% dist = dist_L2betweeen(x, y)
% Compute the sum of pairwise L_2 distance between vectorized
% networks x  and y.
%
% dist is similar to the between-group loss defined in Songdechakraiwut, 
% T., Shen, L., Chung, M.K. 2021 Topological learning and its application 
% to multimodal brain network integration, MICCAI, 12902:166-176
% https://pages.stat.wisc.edu/~mchung/papers/song.2021.MICCAI.pdf
%
%
% INPUT
% x: a matrix of vectorized networks in group1: nGroup1 x nEdges
% y: a matrix of vectorized networks in group2: nGroup2 x nEdges
%
% OUTPUT:
% dist: the distance between the networks in the groups
%
%
% (C) 2022 Zijian Chen, Sixtus Dakurah, Moo K. Chung
%          University of Wisconsin-Madison
%
% Contact mkchung@wisc.edu 
% for any inquary about the code. The code is downloaded from
% https://github.com/laplcebeltrami/hodge

z = [x; y];
m = size(z, 1);

vec=[];
for jj = 1:size(x,1)
    diff_jj = z(jj, :)-z(size(x,1)+1:m,:);
    vec = [vec;vecnorm(diff_jj,2,2)]; %if vecnorm(diff_jj,1,2), we get L1-distance
end
dist = sum(vec);

