function Cmat = Hodge_graident(Yg,pSkeleton)
%function Cmat = Hodge_graident(Yg,pSkeleton)
% This function creates the gradient network (matrix) from pSkeleton
%
% INPUT 
%     Yg gradient component
%% OUTPUT: Curl matrix


%function Cmat = HD_Gradnet(Yc,pSkeleton)
% The function creates the gradient network using the curl component
% INPUT 
%   Yc        : curl component
%   pSkeleton : list of sekeletons obtained from Hodge_2Skeleton.m
%
% OUTPUT
%   Cmat      : Curl matrix
%
% 
% (C) 2022 Vijay Anand D, Moo K. Chung
%          University of Wisconsin-Madison
%
% The code is downloaded from 
% https://github.com/laplcebeltrami/hodge

upper_tri_vec = Yg;
elist=pSkeleton{1,2};
lenelist=size(elist,1);
for ii=1:lenelist
    kk=elist(ii,1);
    ll=elist(ii,2);
    Cmat(kk,ll)=upper_tri_vec(ii,1);
    Cmat(ll,kk)=Cmat(kk,ll);
end