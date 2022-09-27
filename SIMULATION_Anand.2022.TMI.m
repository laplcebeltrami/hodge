% The code performs cycle extraction and modeling using Hodge Laplacian.
% The method is presented in 
%
% Anand, D.V., Dakurah, S. Chung, M.K. 2022
% Hodge-Laplacian of brain networks and its application to modeling cycles.
% arXiv:2110.14599 https://arxiv.org/pdf/2110.14599.pdf
%
%
% The paper is included with the Matlab zip file. 
% If you are using any part of the codes, please reference the above paper.
%
%
% (C) 2021 Vijay Anand D, Moo K. Chung
%          University of Wisconsin-Madison
%
% Contact mkchung@wisc.edu for the maintainance of codes and support.  
%
% Update history
%     2021 November 1, created  Vijay Anand
%     2021 December 3, edited Moo Chung
%     2022 September 28, more edit Moo Chung


clear all
clc

%------------
%Baseline network models
%Generate networks of 1-loop, 2-loops and 4-loops
% G,P,H are adjacency(distance) matrices
% nodesG, nodesP, nodesH are coordinates of the network

sigma = 0.02;
%theta = 0:0.1:2*pi;
theta = linspace(0,2*pi,64); %64 nodes network

[G,nodesG] = graph_loops(1, sigma,theta);
[P,nodesP] = graph_loops(2, sigma,theta);
[H,nodesH] = graph_loops(4, sigma,theta);


figure; 
subplot(3,2,1);
plot(nodesG(:,1),nodesG(:,2),'ok')
G1 = graph(G); 
subplot(3,2,2); 
plot(G1,'XData',nodesG(:,1),'YData',nodesG(:,2))

subplot(3,2,3);
plot(nodesP(:,1),nodesP(:,2),'ok')
subplot(3,2,4); 
P1 = graph(P); 
plot(P1,'XData',nodesP(:,1),'YData',nodesP(:,2))

subplot(3,2,5);
plot(nodesH(:,1),nodesH(:,2),'ok')
subplot(3,2,6); 
H1 = graph(H); 
plot(H1,'XData',nodesH(:,1),'YData',nodesH(:,2))


%--------------------
%  Set the number of networks in each loop type
nG = 5;
nP = 5;
%  Generate nG number of networks of X type
for i=1:nG   
    [g1{i},~] = graph_loops(1, sigma,theta);
end  
%  Generate nP number of networks of X type
for i=1:nP 
    [g2{i},~] = graph_loops(2, sigma,theta);
end 

% Total number of networks
nNetworks = nG+nP;

% Concatenate the networks Group 1 and Group 2 as g
g = [g1 g2];
nc = length(g); % Total number of networks

%Average network (template) obtained by averaging connectivity matrices
%This is wehere we build cycle basis
for ii = 1:nc
    gALL(:,:,ii) = g{1,ii};
end
gAvg = mean(gALL,3);

% 1-cycle basis of template
kCycleVect = Hodge_kCycle(gAvg);


for ii=1:length(kCycleVect)
    kCyclebasis(:,ii) = kCycleVect{:,ii};
end
phi = kCyclebasis;


%Estimate expanion coefficients with respect to the common 1-cycle basis
%CorrVector = kCycleBasis*Coefficients

npoints = length(theta); % currently set at 64
CorrVect  = mat2vec(gALL,nc,npoints);
for i=1:nc 
    V = CorrVect(:,i);
    Coeff(:,i) = inv(phi'*phi)*phi'*V;
end
Gkcycle = Coeff;


% Create Group 1 and Group 2 from 1-cycle basis coefficients
x = Gkcycle(:,1:nG)';
y = Gkcycle(:,nG+1:end)';


%Permutation test on x and y using stat. 
observed_distance = max(abs(mean(x)-mean(y))); % Observed Statistics

per_s = 10000; %# of permutations
stat = inline('max(abs(mean(x)-mean(y)))'); %test statistic 
[stat_s, time_s] = test_permute(x,y,per_s,stat); % stat function as input
pvalues = online_pvalues(stat_s, observed_distance);
pvalend = pvalues(end)

% Summary statitics: 
% figure;
% subplot(1,2,1); 
% histogram(stat_s,'FaceColor',[0.7 0.7 0.7],...
%     'NumBins',10);
% hold on
% plot([observed_distance observed_distance],[0 10000],'--r','linewidth',2);
% xlabel('Test Statistic')
% set(gcf, 'Position', [400 400 600 250])
% set(gca, 'fontsize',16)
% 
% subplot(1,2,2);
% plot(pvalues,'k','linewidth',2); %plot shows the convergence 
% xlim([0 10000]); ylim([0 1.0]);
% ylabel('p-values');
% set(gcf, 'Position', [400 400 600 250])
% set(gca, 'fontsize',16)
%print(gcf,'10_histlencycle_12.png','-dpng','-r300'); %save image as 300dpi 





