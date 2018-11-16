function [cm_f]=StimCovMat(im,ws);
%[cm_f]StimCovMat(im,ws);
%
% Computes the covariance matrix of the non-overlapping image patches of
% window size WS, extracted from images with indices given in IM. The cm_f
% is a square and symmetric matrix with the size of WS*WS*3. It is three
% times bigger then the number of pixels in a patch simply because of 3
% color channels. The results are saved in the $/CovMat; For more details
% see the report PCA_analysis.tex.
%
%
%
%Selim,  01-Nov-2007 11:30:01

c   = 0;
tim = length(im);
%
WritePath = [ mfilename '_Image_' SummarizeVector(im) '_WS_' mat2str(ws) ];
WritePath = ['/mnt/sonat/project_Integration/CovMat/' WritePath];
%
cm_f = zeros(ws*ws*3);
for ni = im
    c = c+1;
    display([mfilename ': computing covariance matrix: ' mat2str( c./tim*100 ) ' % completed.'])
    %laod the image
    [DKL]  = Load_DKLImage(ni);
    %GET THE PATCHES AND RESHAPE THEM
    p      = Image2Patch(DKL,ws);
    tPatch = size(p,4);
    p      = reshape(p(:),ws*ws*3,tPatch);
    p      = p';
    %subtract the mean;
    p      = p-repmat(mean(p),size(p,1),1);
    %compute the covariance matrix
    cm   = cov(p,1);
    %
    cm_f = cm_f + cm;
end
display([mfilename ': saving covariance matrix'])
cm_f = cm_f./tim;
cm = cm_f;
save(WritePath,'cm')