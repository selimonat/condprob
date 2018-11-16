function [v,d]=StimCovMat2PCA(im,ws)
%[v,d]=StimCovMat2PCA(im,ws)
%
%
% IM and WS are the parameters used to compute the covariance matrix with
% the function StimCovMat. Here we open that covariance matrix and we
% diagonalize it. V and D are the eigenvalues and -vectors which are the
% output of the function eig
%
%
%Selim,  01-Nov-2007 11:30:01

%
ReadPath = [ 'StimCovMat_Image_' SummarizeVector(im) '_WS_' mat2str(ws) ];
ReadPath = ['/mnt/sonat/project_Integration/CovMat/' ReadPath];
%
WritePath = [ mfilename '_' SummarizeVector(im) '_WS_' mat2str(ws) ];
WritePath = ['/mnt/sonat/project_Integration/CovMat/' WritePath];
%
display([mfilename ': loading the covariance matrix.'])
load(ReadPath);%this loads a variable called CM
%
display([mfilename ': diagonalizing the covariance matrix.'])
[v,d]     = eig(cm);
%
display([mfilename ': saving the results.'])
save(WritePath,'v','d');
