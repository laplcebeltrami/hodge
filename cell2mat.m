function mat  = cell2mat(gg)
% function mat  = cell2mat(gg)
% Converts elements of a cell to vectors and returns the stacked vectors


% (C) 2022 Sixtus Dakurah, Zijian Chen, Moo K. Chung
%     University of Wisconsin-Madison
%
% Contact mkchung@wisc.edu for any inquary about the code. 
%The code is downloaded from https://github.com/laplcebeltrami/hodge
%
% history: 2022 June 30 created by Dakurah and Chen

m = length(gg);

for ii = 1:m
    ggii = gg{ii};
    n = length(ggii);
    mat(ii, :) = mat2vec(ggii, 1, n);
end
end