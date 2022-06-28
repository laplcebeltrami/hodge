% The code performs the simulation study published in 
% 
% Dakurah, S., Anand, D.V., Chung, M.K. 2022
% Modeling Cycles in Brain Networks Using Hodge Laplacian
% Medical Image Computing and Computer Assisted Intervention (MICCAI)
%
% https://github.com/laplcebeltrami/hodge/dakurah.2021.MICCAI.pdf
%
% (1) Given a graph, the code extracts the cycle basis using the Hodge Laplacian
% and modeling connectivity as a linear combination of cycels basis.
%
% (2) The provided simulation generates random graphs with different numbrer of cycles.
% Then compares the performance of the proposed 1-cycle basis method
% against Eucliden distances (L1, L2, L_infity) and the Gromov-Hausdorff
% (GH)distance. 
%
%
% If you are using any part of the codes, please reference the above paper.
%
%
% (C) 2022 Sixtus Dakurah, Anand, D.V.,  Moo K. Chung
%          University of Wisconsin-Madison
%
% Contact sdakurah@wisc.edu, vijayanand.4@gmail.com or mkchung@wisc.edu 
% for any inquary about the code. The code is downloaded from
%https://github.com/laplcebeltrami/hodge

%-------------
%Generate 4 groups of random newtorks with p = 50 nodes with different topology
%The code generates Figure 2. 

np=50; %number of nodes in a network
nGroup = 10; %number of networks in each group
ntwk_grps = [1 2 3 4];

[g1, g11] = network_group(nGroup, ntwk_grps(1));
[g2, g22] = network_group(nGroup, ntwk_grps(2));
[g3, g33] = network_group(nGroup, ntwk_grps(3));
[g4, g44] = network_group(nGroup, ntwk_grps(4));

%% Remark: The function network_group.m should be a function of np

subplot(1, 4,1);
plot_network_group(g11, 1)
subplot(1, 4,2);
plot_network_group(g22, 2)
subplot(1, 4, 3);
plot_network_group(g33, 3)
subplot(1, 4, 4);
plot_network_group(g44, 4)

%In this script, we will compare group 1 and 3, which are topologically different.
%Then compute the p-value and the error rate. 

%-------------
% The average network of group 1 and 3
g = [g1 g3]; 
nc = length(g); %total number of networks = 20

for ii = 1:nc
    gALL(:,:,ii) = g{1,ii};
end
gAvg = mean(gALL,3);

%% Remark: If averaged over all the groups, you may get more stable result.
%--------------
% Compute the cycle basis
% For p number of nodes, there are p(p-1)/2 number of edges but
% only beta_1 = (p-1)(p-2)/2 number of indepdent 1-cyles. It is explained in
% Songdechakraiwut, T. Chung, M.K. 2022 Topological learning for brain networks, 
% Annals of Applied Statistics (in press), arXiv: 2012.00675 
% https://arxiv.org/pdf/2012.00675.pdf

kCycleVect = Hodge_kCycle(gAvg); %(p-1)(p-2)/2 = 1176 basis for p=50 nodes
for ii=1:length(kCycleVect)
    kCyclebasis(:,ii) = kCycleVect{:,ii};
end
phi = kCyclebasis; %1225 (# of edges) x 1176 (# of basis)

%--------------
%Spectral expansion of connectivity matrix using the cyclic basis in LSE
%This solves the equation (5) in Dakurah et al (2022) MICCAI.

% Vectorized connectivity = kCycleBasis*Coeff. 

CorrVect  = mat2vec(gALL,nc,np); %1225 (# of edges) x 1176 (# of basis)
for i=1:nc
    V = CorrVect(:,i);  %1125 (# of edges) x 1
    Coeff(:,i) = inv(phi'*phi)*phi'*V;
end
Gkcycle = Coeff;  %1176 (# of basis) x 20 (# of networks)
%Gkcycle is the estimated alpha in equation (5)

%------------
% Mmaximum gap statistic in equation (6)

%Group 1 and Group 2 cycle basis
x = Gkcycle(:,1:nGroup)';
y = Gkcycle(:,nGroup+1:end)';

%  Observed test statistic of equation(6)
observed_distance = max_stat(x, y);

%% Remark: If you connect the statitic to existing 
%% distances such as bottleneck and Wasserstein distance,
%% there will be more impact.

% p-value computation using the permutation test
per_s = 10000;
[stat_s, ~] = test_permute(x,y,per_s, @max_stat);
pvalues = online_pvalues(stat_s, observed_distance);
pvalend = pvalues(end) 

%% Baseline codes will be distributed later. 

