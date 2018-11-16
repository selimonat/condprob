function [r]=IOV(fixmat,image,varargin)
%[r]=IOV(fixmat,image,varargin)
%
%
%We have to compute the IOV of a fixmap in accordance with the size of the
%saliency map. therefore IOV is also a function of the size of the matrix.
%And the important thing is to keep the size of the fixmap during IOV
%computation the same as the size of Saliency map. Therefore VARARGIN can
%be used to determine the relevant parameters such as kernel, CA, BF. It
%must be a parameter structure either as the output of GetParameters or the
%strcuture P in the output of Saliency.
%
%
%Selim, 29-Aug-2008 17:16:11


trun  = 50;
ss    = unique(fixmat.subject);
tss   = length(ss);
mid   = round(tss/2);
%
if ~isempty(varargin)
    %values from the input
    kernel= varargin{1}.kernel;
    CA    = varargin{1}.CropAmount;
    BF    = varargin{1}.bf;
else
    %default values: these are actually the same parameters as in the
    %GetParameters. 
    kernel= GetGauss(45);
    CA    = 0;
    BF    = 2;
end
%
timage = length(image);
r      = zeros(trun,timage,'single');%init output
%
counter = 0;
for nimage = image
    counter = counter + 1;
    fixmat2 = SelectFix(fixmat,'image',nimage);
    for nrun = 1:trun
        ssr     = randsample(ss,tss,0);
        %
        fixmap1 = fixmat2fixmap(fixmat2,kernel,CA,BF,'fix',2:1000,'subject',ssr(1:mid));
        fixmap2 = fixmat2fixmap(fixmat2,kernel,CA,BF,'fix',2:1000,'subject',ssr(mid+1:end));
        %
        r(nrun,counter) = single(corr2(fixmap1(:),fixmap2(:)));
    end
end