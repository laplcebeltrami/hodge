function Cmat =Hodge_project(YY,pSkeleton)
%function Cmat =Hodge_project(YY,pSkeleton)
% The function creates the gradient or curl network skeletons
% INPUT 
%   YY        : curl or gradient components in the vectorized form along all
%               edges
%   pSkeleton : list of sekeletons obtained from Hodge_2Skeleton.m
%
% OUTPUT
%   Cmat      : Curl or gradient matrix
%
% 
% (C) 2022 Vijay Anand D, Moo K. Chung
%          University of Wisconsin-Madison
%
% The code is downloaded from 
% https://github.com/laplcebeltrami/hodge

upper_tri_vec = YY;
elist=pSkeleton{1,2};
lenelist=size(elist,1);
for ii=1:lenelist
    kk=elist(ii,1);
    ll=elist(ii,2);
    Cmat(kk,ll)=upper_tri_vec(ii,1);
    Cmat(ll,kk)=Cmat(kk,ll);
end