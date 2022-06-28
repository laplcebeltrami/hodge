function BasisVector = Hodge_identify1cycle(kSkeleton, evec)
%
% The function computes kcycle and 
% extract only the edges that correspond to the 
% kcycle.
%
%
% INPUT:
% N-size of the network
% 1skeleton
% evec-eigen vector that to identify edges 
% corresponding to non zero entries
%
% OUTPUT
% kCycle - Sparse representation of cycles as 
% a connectivity matrix with unit weights
% edjcnt - length of cycles measured as number 
% of edges that constitute the cycle
%
%
% The method is published in
%
% Anand, D.V., Dakurah, S., Wang, B., Chung, M.K. 2021
% Hodge-Laplacian of brain networks and its application to modeling cycles.
% arXiv:2110.14599 https://arxiv.org/pdf/2110.14599.pdf
%
%
%
% (C) 2021 Vijay Anand, Moo K. Chung
%          University of Wisconsin-Madison
%
% Contact mkchung@wisc.edu for the maintainance of codes and support.
%
% Update history
%     2021 November 11, created Vijay Anand
%     2021 November 25, commented Moo Chung


N = length(kSkeleton{1});

elist = kSkeleton{2};
edjmat = [elist evec];
adjmat = zeros(N,N);
edjcnt=0;
for i = 1:N
    k = edjmat(i,1);
    l = edjmat(i,2);
    if abs(edjmat(i,3)) > 0.0001    
        adjmat(k,l) = edjmat(i,3);
        adjmat(l,k) = edjmat(i,3);
        edjcnt = edjcnt+1;
    end
end
    
kk=1;
for ii =1:N
    for jj=ii+1:N
        BasisVector(kk,1)=adjmat(ii,jj);
        kk=kk+1;
    end
end







