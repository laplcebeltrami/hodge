function HLmat=Hodge_laplacian(IncidenceMat)	
%function HLmat=Hodge_laplacian(IncidenceMat)
%
% This function loads the Incidence Matrix and
% computes the Hodge Laplacian matrix.
%
%   INPUT : Incidence Matrix
%   OUTPUT: Hodge Laplacian matrix
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

IndMat = IncidenceMat{2};
HLmat = IndMat'*IndMat;
