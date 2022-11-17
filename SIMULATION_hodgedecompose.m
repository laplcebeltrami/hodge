% This code performs the Hodge decomposition on simulated modular networks
% in Anand, D.V., Das, S., Dakurah, S., Chung, M.K. 2022
% Hodge-Decomposition of Brain Networks. 
% 
% (C) 2022 Vijay Anand D, Moo K. Chung
%          University of Wisconsin-Madison
%
% The code is downloaded from 
% https://github.com/laplcebeltrami/hodge
%
% Update: November 15, 2022

%-------------------------------------
% Random network simulation based on Beta distribution.
% The model is introduced in section 3.2 in the above publication

nNodeG = 24;   % number of nodes in graph G
nNodeP = 24;   % number of nodes in graph P
nModuleG = 2;  % number of clusters in graph G
nModuleP = 3;  % number of clusters in graph P

% parameters used in the simulation study
% Type I  :
alphaG = 5; betaG  = 1; alphaP = 5; betaP  = 1;
% Type II : alphaG = 5; betaG  = 2; alphaP = 5; betaP  = 2;
% Type III: alphaG = 5; betaG  = 3; alphaP = 5; betaP  = 3;
% Type IV : alphaG = 5; betaG  = 4; alphaP = 5; betaP  = 4;

%nrepeats=10;
%for j=1:nrepeats


nG = 10; % The number of networks in group 1
nP = 10; % The number of networks in group 2

% The number of networks in group 1
for i=1:nG
    g1{i} = graph_modular_betadist(nNodeG, nModuleG, alphaG, betaG);
end
%  Generate nP number of networks in group 2
for i=1:nP
    g2{i} = graph_modular_betadist(nNodeP, nModuleP, alphaP, betaP);
end
% Total number of networks
nNetworks = nG+nP;

% Concatenate the networks Group 1 and Group 2 into g
g = [g1 g2];
nc = length(g); % Total number of networks in g

for sid =1:nc 
    C = g{sid};
    % Hodge Decomposition of the connectivity matrix
    Yvec = adj2vec(C,2); %vectorize the upper triangle matrix
    kSkeleton=Hodge_2Skeleton(C);
    IncidenceMat = Hodge_incidence(kSkeleton);
    [Yg, Yc, Yh] = Hodge_decompose(Yvec, IncidenceMat); 

    %% Create the curl network using the Yc Component
    % It converts vectorized curl and gradident flows into square matrix
    Cmat = Hodge_project(Yc,kSkeleton);
    
    %% Create the gradient network using the Yg Component
    % Cmat = Hodge_project(Yg,kSkeleton);

    %% Create the harmonic flow using the Yh Component
    % Cmat = Hodge_project(Yh,kSkeleton);
   
    % Compute the birth and death set of the curl network
    N = length(Cmat);  %N = size(bt,1) +1  # of nodes = # of birth values + 1
    [bt, dt] = WS_decompose(Cmat); %birth set bt, death set dt
    birthset(:,sid) = bt(:,3);
    deathset(:,sid) = dt(:,3);
    
end

% Split data into group 1 and group 2
xbirth = birthset(:,1:nG)'; %group 1
xdeath = deathset(:,1:nG)'; %group 1

ybirth = birthset(:,nG+1:end)'; %group 2
ydeath = deathset(:,nG+1:end)'; %group 2

% Observed Statistics on curl component
observed_distbirth = max(abs(mean(xbirth)-mean(ybirth)));
observed_distdeath = max(abs(mean(xdeath)-mean(ydeath)));
observed_dist = observed_distbirth + observed_distdeath;


% Permutation test determining the statistical signifance of observed statistic. 
per_s = 100000;  %number of permutations
m = size(xbirth,1); % sample size in group 1
n = size(ybirth,1); % sample size in group 2
zbirth = [xbirth; ybirth];    % combine the data
zdeath = [xdeath; ydeath];    % combine the data

%tic
stat_s=[];
for i=1:per_s %each iteration gives a permutation
    %random permutation of data z.
    rperm = randperm(m+n);
    zperb=zbirth(rperm,:);
    zperd=zdeath(rperm,:);
    %permuted data is split into group 1 and 2
    xperb=zperb(1:m,:);yperb=zperb(m+1:m+n,:);
    xperd=zperd(1:m,:);yperd=zperd(m+1:m+n,:);

    stat_b = max(abs(mean(xperb)-mean(yperb))); %Wasserstein distance on birth values
    stat_d = max(abs(mean(xperd)-mean(yperd))); %Wasserstein distance on death values
    stat_s(i) = stat_b + stat_d;  %Combined Wasserstein distance (equation 25)
end 
%toc %2.4 seconds

% Online p-value computation
pvalues = online_pvalues(stat_s, observed_dist);
pvalend = pvalues(end);

% Plot histogram to visualize distributions and observations.
% p-value is the area in the right tail.
figure; plot_distribution(stat_s, observed_dist);