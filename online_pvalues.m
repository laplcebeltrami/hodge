function pvalue = online_pvalues(stat, observed)
%function pvalue = online_pvalue(stat, observed)
%
% Computes the pvalue based on the collection of statistics value 
% and observation sequentically. It is needed for various applications
% where we need to know how p-values change. The seqencial p-value 
% computation algorithm is given in 
%
% Chung, M.K., Xie, L, Huang, S.-G., Wang, Y., Yan, J., Shen, L. 2019 Rapid 
% acceleration of the permutation test via transpositions, International 
% Workshop on Connectomics in NeuroImaging, in press. 
% http://www.stat.wisc.edu/~mchung/papers/chung.2019.CNI.pdf
%
% This code is downloaded from
% http://www.stat.wisc.edu/~mchung/transpositions
%
% (C) 2019 Moo K. Chung  mkchung@wisc.edu
% University of Wisconsin-Madison
%
% Update histroy: 2019 May created
%                 2021 Oct. 11 Validation done 
% 
%
% Validaiton against built-in Matlab function normrnd.m with 10000 N(0,1)
% random numbers. 
% norminv(0.95,0,1) = 1.6449 treshold corresponding to pvalue = 1-0.95 probability
% norminv(0.5,0,1) = 0
% norminv(0.05,0,1) = -1.6449
% 
% Based on the above ground truth, we should get p-values

% stat=normrnd(0,1,10000,1);
% observed =-1.6449  %1.6449  
% pvalue = online_pvalues_mkc(stat, observed)
% pvalue(end) 
% 0.0482  0.4889   0.0489


% pvalue can be computed iteratively as
% pvalue(i+1) = (pvalue(i) * i  + ( t(i+1)>=observed ) / (i+1)


n=size(stat,1); % number of statistics.
l=size(stat,2); % numver of variables/connections

pvalue=zeros(n,l);

if observed>=0
    
    pvalue(1,:)= (stat(1)>=observed); %initial p-value. It is either 0 or 1.
    for i=2:n
        pvalue(i,:) = (pvalue(i-1,:) * (i-1) + (stat(i,:)>=observed))/i;
    end
    
else %observed<0
    
    pvalue(1,:)= (stat(1)<=observed); %initial p-value. It is either 0 or 1.
    for i=2:n
        pvalue(i,:) = (pvalue(i-1,:) * (i-1) + (stat(i,:)<=observed))/i;
    end
    
end

