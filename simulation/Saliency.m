function [S]=Saliency(filename,varargin);
%[S]=Saliency(filename,varargin);
%[S]=Saliency(filename,images);
%
%This script transforms a given feature map into a saliency map. It uses
%already binned featuremaps which are stored in $/BinnedFeatureMaps/.
%
%In the default mode, it transform all the featuremaps specified with FILENAME
%into Salieny maps. In addition to this mode you can also specify a set of images 
%to be transformed into saliency maps. This can be done by entering a vector of image
%indices as VARARGIN.
%
%FILENAME is a posterior distribution file!!! From this filename 
%corresponding filenames for the binedges files are derived (so that the
%BinnedFeatureMaps which contains the same filenames as binedges can be
%opened.) This is done  by the help of the function PostDist2BinEdges. The
%derived files names are used to load the binned feature maps (result of
%Feature2Binned). After loading the binned feature map and its posterior
%distributions the  function assigns for each bin its probability of
%fixation. This is the saliency map of those images computed according to
%the posterior probabilities.
%
%To have the feature to saliency transformation to be computed with the
%average (over images) of the posterior distributions use
%SALIENCY_MEANPDF.m. The current function here computes the saliency map of
%each image by using its own posterior distribtions.
%
%
%Info to understand the variables in this function.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%BFM(X,Y) = Z     ==> The feature value of the pixel at position X and Y
%falls down to the bin Z in the equalized histogram.. 
%
%POST = [ A , B ] ==> A B are the PD (column vectors) for image 1 and 2.
%The size of the columns A and B increases with the dimensions of the PD.
%If it is a one dimensional probability function it must have the same
%number of entries as the number of bins which is usually 20. In the 2D
%case it is 400.
%F(X,Y)           ==> F is derived from individual BFMs. In case of say two
%dimensional analysis the saliency value of a pixel can be derived from two
%different BFM maps. Say if in one BFM the pixel is registered to 10th and
%in the other to the 20th bin, we have to search for the entry (10,20) in
%the 2 dimensional PD map. As we are vectorizing all our PDs we have to
%translate (10,20) into a linear index given the size of the PD matrix. F
%is the result of this translation. Finally to F we add a constant which
%increases with the column order. This is to ensure that each image
%receives its saliency values from its own PD values below
%
%
%
%Selim, 17-Dec-2007 10:45:29
%Selim, 21-Dec-2007 22:53:09

S        = [];
res      = [];
basePost = ['~/pi/PostDist/'];
baseFeat = ['~/pi/BinnedFeatureMaps/'];
%
display([mfilename ': loading posterior probabilities: '])
display(filename);
%load probabilities and features
load([basePost filename]);%load the posterior probability. This returns an
%struct array called RES
if isempty(varargin)    
    images = 1:length(res.im);%doesnt matter if it is the first 
%or second or third, ImIndex must ALWAYS be identical...
else
    images = varargin{1};
end
%
[F,S]=LoadBinnedFeat(filename,images);
%There is one specific Posterior probability for each image.
%POST = res.A.Raw(:,images)./res.C.Raw(:,images);

%new saliency model decided with alper
POST = res.A.Raw./(res.C.Raw+res.A.Raw);
%
if res.nDimen > 1    
    Si   = repmat(res.nBin,[1 res.nDimen]);%the size of the posterior distribution 
else  
    Si   = [1 res.nBin];
end
%here we transform the subscripts indices which are in the binned feaetures
%maps into linear indices and during this conversion we also transform the
%data array into uint32. Then we will be able to directly use them on the
%posterior probability maps to create sSiSialiency map 
F      = uint32(sub2ind(Si,F{:}));
%
%here we make a small trick: we add to each column the number of rows there
%are in the posterior distribution matrix so that we can simply use F as
%indices to posterior distribution matrix. However we do it with a for loop
%becoz it is faster than creating the matrix.
tImage = size(F,2);%total number of images
dummy  = linspace( 0 , size(POST,1)*(tImage-1) , tImage);
for nc = 1:size(F,2);
	F(:,nc)      = F(:,nc) + dummy(nc);
end	
	S.data = POST(F);
	S.p     = res.p;%add the parameter file used to compute the PD so that later 
%we know how PDs are computed exactly. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
display([mfilename ': done... '])

    function [feat]=Path2Feat(Path);
        i    = regexp(Path,'/');
        feat = Path(i(end)+1:end);
    end

    function [F,S]=LoadBinnedFeat(filename,images);
        %F and mask are used to compute the SALIENCY. S is the output of
        %the main function it is inited here. The aim of this function is
        %to provide N (N being the dimension of PD) binned feature maps
        %with compatible sizes and cropping amounts so that they don't
        %bother when put next to each other as a vector.

        
        [fo]  = PostDist2BinEdges(filename);
        tfeat = length(fo);%number of features
        %here we load the binned faeture maps. (see FeatureMap2Binned for more
        %info)
        for nfo = 1:tfeat;
            feat(nfo)           = load([baseFeat fo{nfo}]);
            feat(nfo).fmap.data = uint16(feat(nfo).fmap.data(:,images));
        end
        F   = [feat(:).fmap];
        F   = {F(:).data};
        %INIT OUTPUT (output of the MAIN function not this one)
        InitOUTPUT
        clear feat        
        
        function InitOUTPUT
            S         = feat(1).fmap;
            S         = rmfield(S,{'Path','data'});
            for nfo = 1:tfeat%put in the names of the features
                S.Feat{nfo} = Path2Feat(feat(nfo).fmap.Path);
            end
            S.Path    = filename;%this is the path of the posterior probabilities from which the
            %S.data    = zeros(size(feat(nfo).fmap.data,1),tim,'single');
            %store the indices of the images
            S.ImIndex = feat(1).fmap.ImIndex;
        end

    end

end

