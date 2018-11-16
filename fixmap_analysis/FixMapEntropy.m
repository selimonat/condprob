function [h]=FixMapEntropy(fixmat,kernel,CropAmount,ResizeFactor,weight,varargin);
%[h]=FixMapEntropy(fixmat,kernel,CropAmount,ResizeFactor,weight,varargin);
%
%Inputs are directly passed to fixmat2fixmap. VARARGIN can be used in order
%to filter fixations.
%
%
%Selim, 2008-02-29
%Selim, 23-Sep-2008 16:23:17, beautify + adaptation to the new version
%fixmat2fixmap.

tCond = length(unique(fixmat.condition));

for ncond = unique(fixmat.condition)
    ProgBar(ncond,tCond);
    %Images of this condition
    im         = unique(fixmat.image(fixmat.condition == ncond));
    %COMPUTE THE CONTROL MAP'S ENTROPY.
    map        = ...
	fixmat2fixmap(fixmat,kernel,CropAmount,ResizeFactor,weight,'image',im,varargin{:});
    map = map + 10^-17;
    map = map./sum(map(:));
    h(ncond).c = -sum(map(:).*log(map(:)));
    %
    c   = 0;
    tIm = length(im);
    
    %create the most uniform distrubtion to compute the theoretical maximum
    if ncond == 1
        unimap  = ones(size(map));
        unimap  = unimap./sum(unimap(:));
        theomax = -sum(unimap(:).*log(unimap(:)));
    end
    h(ncond).c_normed = h(ncond).c./theomax*100;%Normalize to the theoretical maximum
    
    %
    for i = im
        c=c+1;
        map = ...
		fixmat2fixmap(fixmat,kernel,CropAmount,ResizeFactor,weight,'image',i,varargin{:});
        map = map + 10^-17;
        map = map./sum(map(:));
        h(ncond).a(c)= -sum(map(:).*log(map(:)));%absolute entropy
        h(ncond).a_normed(c)= h(ncond).a(c)./theomax*100;%%Normalize to the theoretical maximum
    end           
    h(ncond).theomax = theomax;
end
