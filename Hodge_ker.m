function [EigVector, EigValue]=Hodge_ker(HLmatrix)
%function [EigVector, EigValue]=Hodge_ker(HLmatrix)
 %   
% The function takes the Hodge Laplacian matrix and 
% outputs eigenvalues and eigenvectors
%
% INPUT: Hodge Laplacian matrix 
%
% OUTPUT: eigen vectors and eigen values 
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



    hdgmtx=HLmatrix; 
    [evec,evalue] = eig(hdgmtx);    
    eigval = diag(evalue);

    for kk = 1: length(eigval)
        if eigval(kk)< 0.00001
            zeig(kk) = fix(eigval(kk));
        else
            zeig(kk) = eigval(kk);
        end
        if ~isempty(~zeig)
            zeroeig= find(~zeig); 
        end
    end

    if ~isempty(zeroeig)
        cnt =1;
        for ii=1:length(zeroeig)
            idx    = zeroeig(ii);
            zeroEVec(:,cnt) = evec(:,idx);
            cnt=cnt+1;
        end
        EigVector = zeroEVec;
        EigValue  = eigval;
    else
        disp('No non-zero eigen values hence no cycle')
        EigVector = [];
        EigValue  = [];
    end
end