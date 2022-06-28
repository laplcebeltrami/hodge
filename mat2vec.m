function GV = mat2vec(gALL,nc,npoints)
% mat2vec(gALL,nc,npoints)
% Convert a matrix to a vector
    for ll = 1:nc
        Corr = gALL(:,:,ll);
        kk=1;
        for ii =1:npoints
            for jj=ii+1:npoints       
                GV(kk,ll)=Corr(ii,jj);
                kk=kk+1;
            end
        end
    end
end