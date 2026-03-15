function [SLM] = PH_SLM(W) 
% function [SLM] = PH_SLM(W) 
%
% Function computes the single linkage matrix of connectivity matrix W
%
% Input : W = p*p distance matrix. To input similarity matrix, do something like max(max(W))-W. 
% Output : SLM = p*p single linkage matrix
%
% See the following paper for detail
%% Lee, H., Chung, M.K., Kang, H., Kim, B.-N., Lee, D.S. 2011. 
%% Computing the shape of brain network using graph filtration and 
%% Gromov-Haudorff metric, MICCAI.6892:302-309.
%% http://www.cs.wisc.edu/~mchung/papers/lee.2011.MICCAI.pdf
%
%
% (C) 2017 Hyekyung Lee, Seoul National University
%  
% 2018 August 11, Comment changed from similarity matrix to distance amtrix for input W.


W = (W + W')/2; 

[row,col] = find(W>0); 
val = W(find(W>0));
tind = find(row<col); 
E = [row(tind) col(tind) val(tind)]; 
p = max(max(E(:,1:2))); 

% Ordering edge weights in ascending order 
% edges with the smalled weights are first connected 
[tval,tind] = sort(E(:,3),'ascend');
E = E(tind,:);

clear cluster; 
SLM = ones(p,p); 
indc = zeros(p,1); 
nc = 0; count = 1; 
for i = 1:size(E,1), 
    c1 = indc(E(i,1)); c2 = indc(E(i,2));
    
    if c1 == 0 & c2 == 0, % nodes that do not belong to any cluster  
        SLM(E(i,1),E(i,2)) = E(i,3); 
        SLM(E(i,2),E(i,1)) = E(i,3); 
        count = count + 1; 
        
        nc = nc + 1; 
        cluster{nc} = E(i,1:2);
        indc(E(i,1:2)) = nc; 
    elseif c1 == c2, % two nodes are already connected 
    elseif c1 > 0 & c2 == 0, % only one node belong to the cluster  
        SLM(cluster{c1},E(i,2)) = E(i,3); 
        SLM(E(i,2),cluster{c1}) = E(i,3); 
        count = count + 1; 
        
        cluster{c1} = [cluster{c1} E(i,2)]; 
        indc(E(i,2)) = c1;
    elseif c1 == 0 & c2 > 0, 
        SLM(cluster{c2},E(i,1)) = E(i,3); 
        SLM(E(i,1),cluster{c2}) = E(i,3); 
        count = count + 1; 
        
        cluster{c2} = [cluster{c2} E(i,1)]; 
        indc(E(i,1)) = c2;
    elseif c1 ~= c2, % two clusters that belong to two nodes are merged 
        SLM(cluster{c1},cluster{c2}) = E(i,3); 
        SLM(cluster{c2},cluster{c1}) = E(i,3); 
        count = count + 1; 
        
        cluster{c1} = [cluster{c1} cluster{c2}]; 
        indc(cluster{c2}) = c1; 
    end
    
    if length(unique(indc)) == 1, 
        break; 
    end
end 


SLM=SLM- eye(p);