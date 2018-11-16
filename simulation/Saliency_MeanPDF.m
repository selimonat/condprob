function [S]=Saliency_MeanPDF(filename);
%[S]=Saliency_MeanPDF(filename);
%[S]=Saliency_MeanPDF(filename);
%
%This script transforms a given feature map into a saliency map. It uses
%already binned featuremaps which are stored in $/BinnedFeatureMaps/.
%
%FILENAME is a posterior distribution file!!! From this filename 
%corresponding filenames for the binedges files are derived. This is done
%by the help of the function PostDist2BinEdges. The derived files names are
%used to load the binned feature maps (result of Feature2Binned). After
%loading the binned feature map and its posterior distributions the 
%function assigns for each bin its probability of fixation. This is the
%saliency map of those images computed according to the posterior
%probabilities.
%
%Importantly the saliency is computed on the average posterior
%probabilities therefore the image specific information is lost. USE
%SALIENCY.m to have the saliency map of each image.
%
%
%
%
%Selim, 01-Aug-2007 14:32:11
%Selim, 13-Dec-2007 22:29:55; Adapted for NNNNNnnnnnnnn dimensions!!!!



S        = [];
res      = [];
%
%
%
basePost = ['~/pi/PostDist/'];
baseFeat = ['~/pi/BinnedFeatureMaps/'];
%
%load probabilities and features
load([basePost filename]);%load the posterior probability. This returns an
%struct array called RES

%
%transform the posterior distribution filename 2 the corresponding bin
%edges file names. As the filenames of binedges and the binnedfeaturemaps
%is same then we can load the binnedfeaturemaps maps

%
[F,mask,S]=LoadBinnedFeat(filename);
%
%
%
%here we put the posterior distribution to its genuine matrix like shape.
%In case it is 1 dimension nothing should matter.
if res.nDimen > 1
    POST = reshape(res.A.MeanPDF./(res.C.MeanPDF + res.A.MeanPDF), repmat(res.nBin , 1 , res.nDimen ));
    Si   = repmat(res.nBin,[1 res.nDimen]);%the size of the posterior distribution 
else
    POST = res.A.MeanPDF./(res.C.MeanPDF + res.A.MeanPDF);
    Si   = [1 res.nBin];
end
%
%
%here we transform the subscripts indices which are in the binned feaetures
%maps into linear indices. Then we will be able to directly use them on the
%posterior probability maps to create saliency map
%
ii     = sub2ind(Si,F{:});
S.data = POST(ii);%POST IS A SINGLE VECTOR HERE. IN THE SALIENCY.M IT IS A
%MATRIX
S.data(mask,:) = NaN;

%one thing remains we have to cancel all the pixels which have their
%positions on the zero-padded area. I computed above specifies which of the
%features maps has a bigger cropping amount therefore we use that value to
%NaNize all the pixels covered.




    function [feat]=Path2Feat(Path);
        i    = regexp(Path,'/');
        feat = Path(i(end)+1:end);
    end

    function [F,mask,S]=LoadBinnedFeat(filename)
        %F and mask are used to compute the SALIENCY. S is the output of
        %the main function it is inited here.

        
        [fo]  = PostDist2BinEdges(filename);
        tfeat = length(fo);%number of features
        %here we load the binned faeture maps. (see FeatureMap2Binned for more
        %info)
        for nfo = 1:tfeat;
            [baseFeat fo{nfo}]
			feat(nfo) = load([baseFeat fo{nfo}]);
            mask{nfo} = GetZeroPadMask(feat(nfo).fmap.CurrentSize,feat(nfo).fmap.ZeroPadAmountinOriginal);
            %here comes the trick: MASK is 1 on the pixels which have their
            %coordinates placed on the zero-padded pixels. But temporaly put these
            %pixels to a value of one so that below the sub2ind doesn't give the
            %out of range error.
            feat(nfo).fmap.data(mask{nfo}(:),:) = 1;
            feat(nfo).fmap.data  = uint16( feat(nfo).fmap.data );
        end

        [i]=GetBiggerCA(feat);%i must be the index of the featuremap which has the 
        %biggest cropping amount. in case there are eqaul
        mask = mask{i};
        %we need to have all the binned feature maps easily
        %accessible. Specifically we would like to be able to use them like this:
        %i = sub2ind(SIZE OF THE POSTDIST , [FMAP1], [FMAP2],[FMAP3]...)
        %then we can use i is simply like this POSTDIST(i) to get the saliency.
		F   = [feat(:).fmap];
        F   = {F(:).data};
        %we have now N cell arrays which contains N big matrices 
        %organized as (pixels,images) where each entry corresponds to a given bin
        %in the posterior probability distributions. N is equal to the number of
        %dimensions in the input filename.
        %
        %
        %INIT OUTPUT (output of the MAIN function not this one)
        InitOUTPUT
        clear feat        
        
        function [i]=GetBiggerCA(feat)
            %here we find which of the feature has higher cropping amounts.
            dummy = [feat(:).fmap];
            dummy = [dummy(:).ZeroPadAmountinOriginal];
            i     = find (dummy == max(dummy),1);
        end


        function InitOUTPUT
            S         = feat(1).fmap;
            S         = rmfield(S,{'Path','data'});
            for nfo = 1:tfeat%put in the names of the features
                S.feat{nfo} = Path2Feat(feat(nfo).fmap.Path);
            end
            S.path    = filename;%this is the path of the posterior probabilities from which the
            %S.data    = zeros(size(feat(nfo).fmap.data,1),tim,'single');
        end

    end

end

