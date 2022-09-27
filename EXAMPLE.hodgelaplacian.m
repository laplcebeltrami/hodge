% Example showing how to compute the Hodge Laplacian explained in
%
% Anand, D.V., Dakurah, S., Chung, M.K. 2022 
% Hodge-Laplacian of brain networks and its application to modeling cycles.
% arXiv:2110.14599 
% 
% Dakurah, S., Anand, D.V., Chen, Z., Chung, M.K. 2022 Modeling cycles in
% brain networks with the Hodge Laplacian, MICCAI LNCS 13431:326-335.
%
%https://github.com/laplcebeltrami/hodge/blob/main/dakurah.2022.MICCAI.pdf


%% https://arxiv.org/pdf/2110.14599v1.pdf
%% Version 1 of arXiv has detailed explanation of Figure 2 example in Page 8.
%
%
% The code downloaded from https://github.com/laplcebeltrami/hodge
%
% (C) 2022 Moo K. Chung
%          University of Wisconsin-Madison
%
% Contact mkchung@wisc.edu for the maintainance of codes and support.  
%
% Update history
%     2022 Septermber 28, crediated Moo Chung


%% Figure 2 example in the paper

%boundary operator (# of nodes x # of edges)
%This is the indidence matrix in graph theory
B1= [-1 -1  0  0  0  0
      1  0 -1 -1  0  0
      0  1  1  0 -1  0
      0  0  0  1  0 -1
      0  0  0  0  1  1];

%boundary operator (# of edges  x # of triangles)
B2 = [1
     -1
      1
      0
      0
      0]

%1st Hodge Laplacian. This include the filled-in triangle.
%In Anand's paper, we simply ignored the filled-in triangle so 
%L1 = B1'*B1
% If you want to have B2, you MUST define a rule for forming a connectiity
% of 3 nodes. 

L1 = B1'*B1 + B2*B2'

%L1=[3     0     0    -1     0     0
%    0     3     0     0    -1     0
%    0     0     3     1    -1     0
%   -1     0     1     2     0    -1
%    0    -1    -1     0     2     1
%    0     0     0    -1     1     2]
   
[V1, D1]= eig(L1)
%There is only one cycle so we have 1 zero eigenvalue.
%The first column of V1 corresponds to the cycle.

%V1 =
%
%    0.1741    0.3717   -0.2409   -0.5774   -0.6015   -0.2799
%   -0.1741    0.3717    0.2409    0.5774   -0.6015    0.2799
%   -0.3482   -0.0000    0.4817   -0.5774    0.0000    0.5598
%    0.5222    0.6015   -0.1489   -0.0000    0.3717    0.4529
%   -0.5222    0.6015    0.1489    0.0000    0.3717   -0.4529
%    0.5222    0.0000    0.7795    0.0000   -0.0000   -0.3460

%eigenvalues    
%D1 =
%   -0.0000         0         0         0         0         0
%         0    1.3820         0         0         0         0
%         0         0    2.3820         0         0         0
%         0         0         0    3.0000         0         0
%         0         0         0         0    3.6180         0
%         0         0         0         0         0    4.6180

%Filled-in triangle is simply ignored. So there is a cycle. Then
%Hodge Laplacian is simply L1 = B0'B0 + B1*B1', where B0 is 0.
L1simple = B1'*B1

%L1simple= 
%     2     1    -1    -1     0     0
%     1     2     1     0    -1     0
%    -1     1     2     1    -1     0
%    -1     0     1     2     0    -1
%     0    -1    -1     0     2     1
%     0     0     0    -1     1     2

%-----------------
%Using Anand's codes on the same example

% Adjacency matrix
% In practice, we obtain this by thresholding correleation matrix.
% The rule for where to treshold should be emprically determined.
% In Anand's paper, we thresholded at zero.

ConnMat = [ 0 1 1 0 0 
            1 0 1 1 0
            1 1 0 0 1
            0 1 0 0 1
            0 0 1 1 0]

%Visual check: MATLAB format of graph constructed as structued array
graphmat = graph(ConnMat) 
figure; plot(ans)

% Generate k-skeleton from a given adjacency matrix
kSkeleton = Hodge_1Skeleton(ConnMat)

%kSkeleton =
%  1×2 cell array consisting of nodes set and edge set
%    {5×1 double}    {6×2 double}

%kSkeleton{1}   :Node set
%ans =
%     1
%     2
%     3
%     4
%     5

%kSkeleton{2}   :Edge set
%ans =
%     1     2
%     1     3
%     2     3
%     2     4
%     3     5
%     4     5

% Create boundary matrix from the k-Skeleton
IncidenceMat= Hodge_incidence(kSkeleton);

%IncidenceMat =
%  1×2 cell array
%    {0×0 double}    {5×6 double}

%IncidenceMat{2}
%ans =
%    -1    -1     0     0     0     0
%     1     0    -1    -1     0     0
%     0     1     1     0    -1     0
%     0     0     0     1     0    -1
%     0     0     0     0     1     1

% Ignoring the sign, it exactly matches to boundary matrix B1 
% computed by hand above


% Create Hodge Laplacian matrix from the boundary matrix
Laplacemat=Hodge_laplacian(IncidenceMat);
%
%Laplacemat =
%     2     1    -1    -1     0     0
%     1     2     1     0    -1     0
%    -1     1     2     1    -1     0
%    -1     0     1     2     0    -1
%     0    -1    -1     0     2     1
%     0     0     0    -1     1     2

% Eigenvectors corresponding to the kernel of Hodge Laplacian matrix
[EigVector,~] = Hodge_ker(Laplacemat);

%Since we ignored filled-in triangle, there should be 2 cycles.
%EigVector =
%    0.5692   -0.1992
%   -0.5692    0.1992
%    0.5921    0.3225
%   -0.0229   -0.5217
%    0.0229    0.5217
%   -0.0229   -0.5217

%The above function is same as

[V1, D1]= eig(Laplacemat)
%V1 =
%    0.5692   -0.1992   -0.3717   -0.2409   -0.6015   -0.2799
%   -0.5692    0.1992   -0.3717    0.2409   -0.6015    0.2799
%    0.5921    0.3225   -0.0000    0.4817         0    0.5598
%   -0.0229   -0.5217   -0.6015   -0.1489    0.3717    0.4529
%    0.0229    0.5217   -0.6015    0.1489    0.3717   -0.4529
%   -0.0229   -0.5217   -0.0000    0.7795   -0.0000   -0.3460

%D1 =
%   -0.0000         0         0         0         0         0
%         0   -0.0000         0         0         0         0
%         0         0    1.3820         0         0         0
%         0         0         0    2.3820         0         0
%         0         0         0         0    3.6180         0
%         0         0         0         0         0    4.6180
