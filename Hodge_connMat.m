function ConnMtx = Hodge_connMat(N,bt,dt,cid)
% This function construct the connectivity matrix for each 1-cycle
% Each cycle is constrcuted by adding one edge at a time to the
% maximum spanning tree (MST). The method is published in
%
% Anand, D.V., Dakurah, S., Wang, B., Chung, M.K. 2021
% Hodge-Laplacian of brain networks and its application to modeling cycles.
% arXiv:2110.14599 https://arxiv.org/pdf/2110.14599.pdf
%
% INPUT
% N - Size of Connectivity Matrix
% bt- Birth Matrix
% dt- death Matrix
% cid-cycle id
%
% OUTPUT
% ConnMtx - Connectivity matrix for Eeach cycle. Saved as logical (binary)
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


    N = size(bt,1) +1; % % # of nodes = # of birth values + 1
    
    incdt  = dt(cid,:);
    MSTmat = [bt;incdt];
    
    adjMat = zeros(N,N);
    for i = 1:N
        k = MSTmat(i,1);
        l = MSTmat(i,2);
        adjMat(k,l) = MSTmat(i,3);
        adjMat(l,k) = MSTmat(i,3);
    end
    
    adjnew = adj2bin(adjMat,0);
%     ConnMtx = tril(full(adjnew));
    ConnMtx = full(adjnew);
    %ConnMtx = logical(ConnMtx);
end