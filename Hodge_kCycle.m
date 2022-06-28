function kCycleVect = Hodge_kCycle(C)
% function kCycleVect = Hodge_kCycle(C)
%    
% Computes the 1-cycle basis of given network C. 
% The method is published in  
%
% Anand, D.V., Dakurah, S., Wang, B., Chung, M.K. 2021 
% Hodge-Laplacian of brain networks and its application to modeling cycles.
% arXiv:2110.14599 https://arxiv.org/pdf/2110.14599.pdf
%
% (C) 2021 Vijay Anand, Moo K. Chung
%          University of Wisconsin-Madison
%
% Contact mkchung@wisc.edu for the maintainance of codes and support.  
%
% Update history
%     2021 November 11, created Vijay Anand
%     2021 November 25, commented Moo Chung

N = length(C);  %N = size(bt,1) +1  # of nodes = # of birth values + 1
[bt, dt] = WS_decompose(C); %birth set bt, death set dt
nkcycles = size(dt,1); % # of 1-cycles

for cid = 1:nkcycles
    % disp(strcat('cycle no : ', num2str(cid)))
    % Generate connectivity matrix for each cycle obtained from MST
    ConnMat = Hodge_connMat(N,bt,dt,cid);
    
    % Generate k-skeleton from a given adjacency matrix
    kSkeleton = Hodge_1Skeleton(ConnMat);
    
    % Create boundary matrix from the k-Skeleton
    IncidenceMat= Hodge_incidence(kSkeleton);
    
    % Create Hodge Laplacian matrix from the boundary matrix
    Laplacemat=Hodge_laplacian(IncidenceMat);
    
    % Eigenvectors corresponding to the kernel of Hodge Laplacian matrix
    [EigVector,~] = Hodge_ker(Laplacemat);
    
    %From skeleton data, identify edges corresponding to the 1-skeleton
%     if ~isempty(EigVector)
%             [GV] = PH_identifyCycle_1(kSkeleton, EigVector);       
%             kCycleVect{cid}  = GV;
%     else
%             [GV] = PH_identifyCycle_1(kSkeleton, EigVector);       
%             kCycleVect{cid}  = GV;
%     end    
    kCycleVect{cid} = Hodge_identify1cycle(kSkeleton, EigVector);
end






