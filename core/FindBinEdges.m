function [BinEdges]=FindBinEdges(FeatureMap,FixMap,nBins)
%[BinEdges]=FindBinEdges(FeatureMap,FixMap,nBins)
%
%In this function, binedges are computed. Binedges divides into NBINS the
%whole feature scale. For example, if we are dealing with mean luminance
%maps, our dynamic range of values is most probably (depending on the
%images) between 0 and 255. The binedges computed in this algorithm divide
%this range into NBINS. The special property of these binedges is that the
%total number of fixations within each bin is equal.
%
%
%FEATUREMAP is a function of space and it contains in its columns the
%featuremaps of different images. Each entry in a given column is the value
%of the feature at that pixel. FIXMAP is the probability density
%function i.e. p(fixation|x,y). Its enties represent the probability of a
%given pixel to be fixated. The sizes of FEATUREMAP and FIXMAP must be
%same.
%
%If the FEATUREMAP is 2D (many images) and FIXMAP is 1D then the same
%FIXMAP is applied to different images' features maps. 
%
%IMPORTANT NOTE: if you want to have binedges detected over the whole
%feature values irrespective of different images, then you may give as
%argument a FIXMAP with the same size as FEATUREMAP. For example assuming
%you have 64 images: 
%FindBinEdges(FeatureMap(:),Vectorize(repmat(FixMap,[1 1 64])),nBins) 
%
%
%Version 1.0; 16.10.2006
%
%Selim Onat AND Frank Schumann, (2006), any comments, questions etc. can be
%mailed to {sonat,fschuman}@uos.de.
%
%Current Problems: Detecting the bin edges in a pooled way could be
%carried out more easily, but how? 
%
%


%check for number of pixels in each FEATUREMAP and FIXMAP
tPix = size(FeatureMap,1);
if tPix == length(FixMap(:))

    %1. Detect the BinEdges for each of the images
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    display('Finding the Edges.');
    tIm = size(FeatureMap,2);
    display([repmat(' ',1,tIm-1) '|']);
    for ni = 1:tIm

        fprintf('.');     
        %Heal repetitivity. At some images the ones specially which contains big
        %regions of flat luminance such as sky or fractals, the number of
        %zeros are exceedingly too high. This generates a problem while we
        %are detecting bin edges. The reason is the following: in case we
        %have 20 bins each bin must contain 0.05 of fixation weight. In
        %these special images it can happen that we fullfill 0.05 fixation
        %weight requirement but still we are stuck in the same feature
        %value which is 0. Therefore the solution is to add a random noise
        %to the zeros so that they are not detected as one value.
        %        
%         u = unique(FeatureMap(:,ni));
%         i = find(u ~= 0 , 1);%find the first non-zero element
%         FeatureMap(:,ni) =  FeatureMap(:,ni) + rand(tPix,1)*u(i)/1000;        
        %THIS IS NO MORE TREATED HERE!!, INSTEAD I ADD NOISE TO THE
        %FEATUREMAPS DIRECTLY AND SAVED THEM.
        %
        %01-Oct-2008 %Some updates to this issue:
        %So far we were dealing with this problem by adding noise to the
        %computed feature maps. Thanks to this method the findbindedge
        %algoritm which is implemented in this function was used without
        %any major modification of the code. 
        %However eventhough the little noise added to the pixels copes well
        %with the bin edge detection failures, another problem rises with
        %this method. This is becoz of the fact that we assign many bins to
        %the same feature value (namely zero in most cases). This creates a
        %flat line of p(fix|features) curves. And indeed it creates even
        %more problems in the case of 2D distributions where the joint
        %distribution between features shows up with bandlike structures.
        %If the percentile increases and the absolute value stays constant
        %this creates an odd situation and causes the entropy to
        %artificially increase or decrease. So the idea is now to put all
        %this zero values in the first bin in case the number allowed by a
        %given bin is smaller than the total number of zeros (weighted by
        %the control fixation map). 
        %
        %18-Nov-2008 %Some more updates to this issue: What is written
        %above is completely true however the strategy we chose is now
        %different. I still prefer the first method of adding noise to the
        %feature maps. In most of the cases the noise is added to only a
        %limited amount of pixels. No excessive cases of adding noise to
        %50% of the pixels is necessary. For more information see the
        %report 1D_dists_pooled.pdf. However one novelty is that the noise
        %is now added on the fly during the call of this function. Before
        %they were added on the maps irreversibly. In future the piece of
        %code below to do this can be transformed into a function. I will
        %basically use the code which is written above and later
        %deactivated :-)
        %
        %ADD THE EPSILON RANDOM NOISE:
        %Find the smallest non-zero entry's value. We will use this index-1
        %to sum over all the fixation values to see the weight of the all
        %zero entryies. We will add a noise to all the pixels in the
        %feature maps, the amount of the noise will be dependent on the
        %smallest non-zero entry within the features. The maximum noise
        %added will be one FACTORTH of the smallest element.
        %
        %this are now again commented out becoz we will make the random
        %epsilon addition outside of this function.
% % % %         factor = 1000;
% % % %         %the first non-zero element
% % % %         M  = unique(FeatureMap(:,ni));
% % % %         i  = find(M ~= 0 , 1);%find the first non-zero element...
% % % %         M  = M(i);
% % % %         %The position and number of zero elements.
% % % %         zi = find(FeatureMap(:,ni) == 0);%zero entry indices...
% % % %         tzi= length(zi);%total number of zero entries
% % % %         FeatureMap(zi,ni) =  FeatureMap(zi,ni) + rand(tzi,1)*(M/factor);       
        %
        %
        %sort the Feature map
        [FeatM_s i] = sort((FeatureMap(:,ni)));
        if tIm == 1%we delete the feature map in case of pooled analysis where tIm = 1
        clear FeatureMap;
        end
        %here i contains the ordered indices of the pixels in FEATUREMAP such that
        %FEATUREMAP(i(1)) is the smallest entry and FEATUREMAP(i(end)) is the
        %biggest featurevalue.        
        %        
        %We use this index information to order the fixation map. This gives us how
        %the fixation density (or in the discrete case, the number of fixations)
        %for the different features ordered from smallest to biggest.
        FixMap_sorted = FixMap(i);
        clear i;%we dont need it anymore.        
        %
        %make a cumulative sum of the FixMap.
        FixMap_cs  = cumsum(FixMap_sorted);
        %the cumulatif function ends at one as the fixation map is probability
        %distribution. Let's call this value the last value. The first
        %value fixation weight associated with the lowest feature value and it
        %needs not to be 0. And let's call this value the first value. What we want is to
        %divide the interval between the first value and the last value into NBINS.
        %where each bin has to contain (FIRST-LAST)/NBINS fixation weights. Let's
        %call (FIRST-LAST)/NBINS the increment. Then the problem can be solved by:
        %FirstValue = FirstValue + Increment*k.
        %As a consequence: when k is equal to 0, this will give the first binedges
        %which is the smallest value. when k is equal to 1, this will give us the
        %second bin edges and so on. Therefore K runs until NBINS+1.


        %increment of fixation density
        Increment = (FixMap_cs(end)-FixMap_cs(1))./nBins;
        %                        
        %BinEdges in the Fixation Density scale
        BinEdges2      = FixMap_cs(1) + (0:nBins)*Increment;
        %we enter explicitely by hand the upper/lower binedges. Due to some
        %round off erros if these values are not exactly entered then we
        %risk to have out of range values during binning procedure. And
        %as those out of range values are coded as 0 in the histc, we end
        %up with a indexing error.
        BinEdges2(end) = FixMap_cs(end);
        BinEdges2(1)   = FixMap_cs(1);
    
        %Find the corresponding feature values.
        %we have to find the corresponding values in the Contrast Scale
        for x = 2:nBins            
            dummyyou  = abs(FixMap_cs - BinEdges2(x));              
            BinEdges(x,ni) = FeatM_s( min(find( dummyyou == min( dummyyou)) ) );
            %in case there is more then one entry in the FIXMAP_CS which
            %corresponds to a given binedge, specified with BINEDGES2(x),
            %than we have to make a decision. As we end up with more than
            %one feature value, we have to take one of them. This should
            %not matter at all for the final results and it is the results
            %of the fact that we can not have perfect equalized binedges.
            %BUT in case we are at the last bin AND there are more then one
            %candidates, then we have a problem by selecting the minimum of
            %them, this would result to the exclusion of the biggest
            %feature value. That is why we are computing the last bin
            %outside of the for loop and with max operator.
        end         
            x = nBins+1;
            dummyyou       = abs(FixMap_cs - BinEdges2(x));              
            %BinEdges(x,ni) = FeatM_s( max(find( dummyyou == min( dummyyou))));
            %
            BinEdges(x,ni) = +Inf;
            BinEdges(1,ni) = -Inf;
            %why not replace this with BinEdges - FeatM_s(end)
    end
    fprintf('\n')
else
    display('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
    display('The size of featuremaps and fixation map must match!');
    BinEdges = [];    
    
end
