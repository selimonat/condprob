function [fmap]=FeatureMap2Binned(fmap,be)
%[fmap]=FeatureMap2Binned(fmap,be)
%
%
%This function takes as input a cell array of paths for Binedges files.
%These files contains for each feature and category the 
%histogram equalizing bin edges. For a given Binedge file, it opens its
%corresponding Featuremap and transforms the continous feature values into
%values of bin indices according to the detected bin edges. These maps are
%simply integer maps and very handy to be saved as they dont occupy lots of
%space in the disk. Therefore whenever we need to compute the Saliency
%values we can simply open this files and assign to each integer its
%probability value which is stored in the $/PostDist folder. \
%
%Important Note: all the pixels which have their value smaller then 1, that
%is 0, corresponds to pixels of zero-padding.
%
%
%Example usage:
% in folder where binedges are stored do : f = ListFiles('*.mat');
%and then FeatureMap2Binned(f);
%
%Selim, 01-Aug-2007 11:41:42
%Selim, 13-Dec-2007 11:42:23, corrected bug, the zero-padding pixels were
%used as genuine feature values. this is now overcomed. all the pixels
%which corresponds to zero padding are assigned the value of zero. In
%addition to this I increased the security. Now for each of the feature
%maps which are binned I record the number of times a pixel has a value
%bigger than the number of bins and the number of times a pixel has a value
%smaller then one. These occurences must not happen. The output is written
%in text file in home directory, there you can be sure that there are no
%pixels having <0 and > tbin.
%
%14-Feb-2008 18:02:26, adapted to the resizabitlity options which is know
%enabled. According to that now the BinnedFeature Maps have exactly the
%same size as they were used to compute the Binedges.  


%in case we are dealing with pooled case then the number of images
%is simply 1.
if be.p.pooled == 1
    tim = 1
    fmap.data = fmap.data(:);
else
    tim = length(be.Im);
end
%
tBin = be.p.nBin;
check = [];
for ni = 1:tim;
    %we add a machine epsilon to the last bin so that histc does not count
    %it as a outsider.
    be.data(end,ni) = be.data(end,ni) + eps;
    [foo binned] = histc( fmap.data(:,ni), be.data(:,ni) );
    %assign all pixels which are bigger then the number of bin size to the
    %previous bin. Usually this MUST NOT happen!!!!!!
    %
    check = check + sum( binned(:) == (tBin + 1) );
    fmap.data(:,ni) = binned(:);
end
%transform the stuff to integers.
fmap.data = uint8(fmap.data);
%if there is a problem we destroy output
 if check > 0
 display(['WARNING THERE ARE OUT OF RANGE PIXELS!!!!!!'])        
 fmap = [];
 end
