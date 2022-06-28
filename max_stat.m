function stat = max_stat(x, y)
%function stat = max_stat(x, y)
%
% Compute the maximum absolute difference of the mean of matrix x and y
% introduced in
%
% Dakurah, S., Anand, D.V.,Chung, M.K. 2022 
% Modelling Cycles in Brain Networks using Hodge Laplacian
%
%
% INPUT
% x: m (subjetcs) \times n(cycles) matrix
% y: m (subjetcs) \times n(cycles) matrix
%
% OUTPUT
% stat: n(cycles)-length vetcor. max of the absolute mean of x and y

stat = max(abs(mean(x)-mean(y)));
end