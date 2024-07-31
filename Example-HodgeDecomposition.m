%% This code performs Hodge decomposition of a graph published in
%% Anand, D.V., Chung, M.K. 2024 Hodge Decomposition of Brain Networks, ISBI 
%% https://arxiv.org/pdf/2211.10542
%
% The details on the computation of the Hodge Laplacian is explained in 
% 
% Anand, D.V., Chung, M.K. 2023 Hodge-Laplacian of brain networks, 
% IEEE Transactions on Medical Imaging 42:1563-1473
% https://arxiv.org/pdf/2110.14599.pdf
%
%
% (C) 2024 Anand, D.V., Chung, M.K.  
% University of Wisconsin-Madison
% mkchung@wisc.edu

% INPUT : Connectivity Matrix
% OUTPUT: The gradient, curl and harmonic components Hodge Decomposition


% INPUT : Connectivity Matrix, 5 node example given in Figure 2 of ISBI paper
%         This is same example given in Example 1 in https://arxiv.org/pdf/2110.14599v1


% Load Data
%node 1      2      3      4      5
Y = [0.0    1.0    1.0    0.0    0.0;  %1
    -1.0    0.0    2.0    1.5    0.0;  %2
    -1.0   -2.0    0.0    0.0    1.5;  %3 
     0.0   -1.5    0.0    0.0    0.5;  %4
     0.0    0.0   -1.5   -0.5    0.0]; %5 


% Create k-Skeleton from the connectivity matrix
kSkeleton = Hodge_2Skeleton(Y);

% Create boundary matrices from the k-Skeleton 
IncidenceMat= Hodge_incidence(kSkeleton);

% IncidenceMat{2}
% IncidenceMat{3}
% 
% ans =
% 
%     -1    -1     0     0     0     0
%      1     0    -1    -1     0     0
%      0     1     1     0    -1     0
%      0     0     0     1     0    -1
%      0     0     0     0     1     1
% 
% 
% ans =
% 
%      1
%     -1
%      1
%      0
%      0
%      0

% Hodge decomposition to get components
% Yvec - Vectorised Connectivity
% Yh - Harmonic component
% Yc - Curl Component

Yvec = Hodge_vec(Y);
[Yg, Yc, Yh] = Hodge_decompose(Yvec, IncidenceMat);
[Yg, Yc, Yh, s,z] = Hodge_decompose(Yvec, IncidenceMat);

%% VISUALIZATION

%Node coordinates
%x- and y-coordiante of 5 nodes
% The node coordinates are rotated to have house-like shape
xd = [1.0000,0.3090,0.3090,-0.8090,-0.8090]';
yd = [0.0000,0.8511,-0.8511,0.5878,-0.5878]';
theta = 270;
R = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];
vd = [xd yd];
vc = vd*R;
xc = vc(:,1);
yc = vc(:,2);

%Node coordinate information
coord=[xc yc]
%Edge information
elist = kSkeleton{1,2};

%% PLOT EDGE FLOW 
figure; subplot(1,4,1)

weights = Yvec; %edge weights
graph_directed_plot(coord, elist, weights)
title('Edge flow of given graph')

%%  PLOT GRADIENT FLOW 
subplot(1,4,2)
weights = Yg;
graph_directed_plot(coord, elist, weights)
title('Gradient flow')

%% PLOT CURL FLOW 

subplot(1,4,3)
weights = Yc;
graph_directed_plot(coord, elist, weights)
title('Curl flow')

%%  PLOT HARMONIC FLOW 

subplot(1,4,4)
weights = Yh;
graph_directed_plot(coord, elist, weights)
title('Harmonic flow')


