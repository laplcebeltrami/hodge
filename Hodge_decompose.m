function [varargout] = Hodge_decompose(Yvec, Bmat)
% This function loads the vectorised connectivity matrix and
% computes the Hodge decomposition.
%
% INPUT
%    Yvec: vectorized connectivity matrix. For p x p connectivity matrix, the length of Yvec should be (p-1)/2.
%    Bmat: incidence matrix obtained from Hodge_incidence.m
%
% OUTPUT:  Components of Hodge decomposition gradient curl and harmonic
%    Yg: Gradient flow of size (p-1)/2 x 1   
%    Yc: Curl flow of size (p-1)/2 x 1
%    Yh: Harmonic flow of size (p-1)/2 x 1
%    Optional:
%    s: Intermediate result from the gradient flow optimization
%    z: Intermediate result from the curl flow optimization
%
% The method is explained in 
%
% Anand, D.V., Das, S., Dakurah, S., Chung, M.K. 2022
% Hodge-Decomposition of Brain Networks. 
%
% The paper is included with the Matlab zip file. 
% If you are using any part of the codes, please reference the above paper.
%
% (C) 2022 Vijay Anand D, Moo K. Chung
%          University of Wisconsin-Madison
%
% Contact mkchung@wisc.edu for the maintainance of codes and support.  
%
% Update history
%     2022 April 24, created Anand
%     2022 Nov 15 comment Chung
%     2024 July 30. 5 ouput option added


  d0 = Bmat{2}';
    d1 = Bmat{3}';

    % Hodge Laplacian matrix (L0) node-node
    L0 = (d0') * (d0);

    % Hodge Laplacian matrix (L1) triangle-triangle
    L1 = (d1) * (d1');

    % Divergence
    div = (-d0') * (Yvec);

    % Optimization to find the gradient flow
    [s, flag_s] = lsqr(L0, -div);
    % Gradient Flow
    Yg = d0 * s;

    % Triangular Curl
    curl = d1 * Yvec;
    % Optimization to find the curl flow
    [z, flag_z] = lsqr(L1, curl);

    % Curl Flow
    Yc = (d1') * (z);

    % Harmonic Flow
    Yh = Yvec - Yg - Yc;

    % Conditionally return 3 or 5 outputs
    if nargout == 3
        varargout = {Yg, Yc, Yh};
    elseif nargout == 5
        varargout = {Yg, Yc, Yh, s, z};
    end
end



