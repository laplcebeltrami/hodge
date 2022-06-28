function [stat_s, time_s] = test_permute(x,y,per_s, stat)
%function [stat_s, time_s] = test_permute(x,y,per_s, stat)
% The function computes the two-sample test statistic of data vector x and y 
% using the standard permutation test. If follows the method explained in 
%
% Chung, M.K., Xie, L, Huang, S.-G., Wang, Y., Yan, J., Shen, L. 2019 
% Rapid acceleration of the permutation test via transpositions, 
% International Workshop on Connectomics in NeuroImaging, 
% Lecture Notes in Computer Science 11848:42-53 
% http://www.stat.wisc.edu/~mchung/papers/chung.2019.CNI.pdf
% 
% Please reference the paper if you are using the function.
%
% INPUT
% x    : input vector data of size m x l (m= number of subjects, l=number of data per subject) 
% y    : input vector data of size n x l (n= number of subjects, l=number of data per subject)
% per_s: number of permutations
% stat : test statitic as function. 
%        example:
%            KS-test  stat = inline('max(abs(mean(x)-mean(y)))');
%            two-sample t-stat stat =
%                     stat = inline('mean(x)-mean(y)).*sqrt(m*n*(m+n-2)./((m+n)*((m-1)*var(x)+(n-1)*var(y))))');
%        If the test statistic is written as function like stat.m, need to
%        call with @: [stat_s, ~] = test_permute(x,y,per_s, @max_stat);
%     
%
%
% OUTPUT
% stat_s:  two-sample t-statistic of all permutations
% time_s:  run time it took to compute the statistics
%
%
% This code is downloaded from
% http://www.stat.wisc.edu/~mchung/transpositions
%
% (C) 2019- Moo K. Chung, Sixtus Dakurah  
% University of Wisconsin-Madison
% mkchung@wisc.edu
%
% Version history
% 2019 Jun 1 Chung created
% 2021 Dec 5 Chung stat argument added
% 2022 June 28 Sixtus checked the correctness of code

tic

m=size(x,1);
n=size(y,1);
l=size(x,2); %dimension of vector
z=[x; y];  %Combine the data
stat_s=zeros(per_s,l);

for i=1:per_s %each iteration gives a permutation
    zper=z(randperm(m+n), :); %random permutation of data z.
    %Unlike the transposition method, you cannot
    %save the whole permutations in prior since it takes so much memory
    %for large m,n.
    xper=zper(1:m, :);yper=zper(m+1:m+n, :); %permuted data is split into group 1 and 2
    stat_s(i,:)=stat(xper, yper);
end

toc
time_s=toc;
