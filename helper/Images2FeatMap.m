function [FeatMap] = Images2FeatMap(path,ImIndex,varargin)
%[FeatMap] = Images2FeatMap(path,ImIndex,varargin)
%[FeatMap] = Images2FeatMap(path,ImIndex,cropamount,BinningFactor)
%
%
%Read and returns the feature maps referenced with IMINDEX inside the
%path. PATH must be the full path.
%
%By default it removes the zero padding from the maps and stores each map
%in the columns of the DATA field of the FEATMAP as double precision. The
%other fields of the FEATMAP array contains usefull information such that
%the path, the original size of the images, the amount of zero padding, the
%indices of the images, the amount of cropping.
%
%Without any VARARGIN input or an empty VARARGIN value (i.e. []), the zeros
%are automatically removed if there are any. If you prefer to crop the
%feature maps with a given amount of pixels use VARARGIN to specify that
%input. However if you prefer to have the feature maps as they are stored
%(not cropping, no zero removing) use 0 as VARARGIN argument. Second
%VARARGIN if different than empty enrty or zero resizes the featuremaps by
%half. Pay attention to apply the resizing after cropping an appropriate
%amount of zero so that the final image matrix does not end up with a odd
%numbered size. 
%
%The only requirement for this function to read properly the individual
%files, is that the image indices of the individual featuremaps in the filenames
%must be entered between the last underscore and the dot in filename e.g.
%blablabla_blabla_342.mat. The function detects automatically the base name
%which is in this case blablabla_blabla and goes on by reading them one
%after other.
%
%
%
%DEPENDENCY: CropperCleaner
%
%
%Version 1.0; 16.10.2006
%        1.01 24.10.2006 FS change back in directory where you called
%        function.
%	
%	 02-Jun-2007 15:19:45 : adapted to the new featuremaps.
%
%Selim Onat AND Frank Schumann, (2006), any comments, questions etc. can be
%mailed to {sonat,fschuman}@uos.de.
%
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%If the slash is not included in the PATH we introduce it.
if ~strcmp(path(end),'/')
    path(end+1) = '/';
end
%use the local disk in case the computer is fire.
[a b]  = system('hostname');
b(end) = [];
if strcmp(b,'fire')
 % path = LocalizePath(path);
end

if isempty(varargin)%default values
   CA = []; 
   BF = 1;
elseif length(varargin) == 1%default value for the binning factor
   CA = varargin{1};
   BF = 1;
elseif length(varargin) == 2%user defined values
   CA = varargin{1};
   BF = varargin{2}; 
end

%Decide on the resizing algorithm, see fixmat2fixmap for more info on this.
if BF ==2 
    kernel=ones(BF)./BF.^2;
    RSer = @binner_im;
else
    kernel = BF;
    RSer = @binner_2d;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%detect total amount of images in the ImIndex
tIm = length(ImIndex);
%List all the files inside the PATH
files = dir([ path '*.mat']);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~isempty(files);%check whether there are images in the PATH.

    display('reading the files to memory');
    files = {files.name};
    tfile = length(files);
    %we need to find the BASENAME, this is all the string before the last
    %underscore, including the underscore.
    %for this we take one file (we assume that the basename is commun!! to all
    %others) and search for the occurence of the last underscore and crop the
    %text from the first letter till the last underscore. this is our basename
    BaseName = files{1}(1:max(find(files{1} == '_')));
    display([repmat(' ',1,tIm-1) '|']);
    for nf_ =  1:tIm;
        fprintf('.');
        nf = ImIndex(nf_);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %in the first occurence of the for loop we extract usefull
        %information such as the size of the original map, the amount of
        %the zero padding, the amount we are cropping.
        if nf_ == 1;
            dummy = load(sprintf([path BaseName '%03d.mat'],nf));%it returns Feature
            %different people may have recorded their variables within the
            %mat file with different names. that is why here we load
            %the first feature map and we are figuring out the variable name
            %it is recorded.
            variable = fieldnames(dummy);
            %Extract useful information:
            
            %the size of the original featuremap before cropping or
            %whatever as it is in the harddisk
            FeatMap.OriginalSize      = size(dummy.(variable{1}));
            %the amount of zero padding on the feature maps stored in the
            %hard disk before any modification.
            [dummy2 FeatMap.ZeroPadAmountinOriginal ] = CropperCleaner(dummy.(variable{1}));
            %The size of the current featuremap, that means after the
            %cleaning the zeros (as in the default version) or after
            %cropping by force (by the amount given in varargin).
            dummy.(variable{1}) = CropperCleaner(dummy.(variable{1}),CA);        
            FeatMap.CurrentSize = size(dummy.(variable{1}));%we store the size after zero-cleaning or cropping.            
            %The amount which is cropped in the original sized image.
            FeatMap.CropAmount  = (FeatMap.OriginalSize-FeatMap.CurrentSize)/2;
            %We further update the size information of the image after
            %resizing..
            FeatMap.ResizeFactor = BF;
            FeatMap.CurrentSize  = FeatMap.CurrentSize./BF;
            %the path where the features are read out.
            FeatMap.Path  = path;
            
            %And finally we initialize the variable which will store the
            %feature maps in its columns
            FeatMap.data = zeros(prod(FeatMap.CurrentSize),tIm);
            
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        dummy = load(sprintf([path BaseName '%03d.mat'],nf));%it returns Feature
        %store the index of the image
        FeatMap.ImIndex(nf_) = nf; 
        
        %if the varargin is empty, then the default way is taken that is
        %the zeros cleaning. However if it is not empty the amount
        %specified is croped.
        dummy.(variable{1}) = CropperCleaner(dummy.(variable{1}),CA);
        %we will resize the feature map if its required
        if BF ~= 1
[dummy.(variable{1})]=RSer(reshape(dummy.(variable{1}),FeatMap.CurrentSize.*BF),kernel);
        end
        %store it!
        FeatMap.data(:,nf_) = dummy.(variable{1})(:);              
    end    
    fprintf('\n');
    dummy = pwd;%store where we are;
    cd(path);
    FeatMap.Path = pwd;
    cd(dummy);; % go back to dir where you called the function
else
    display('there is no image on this path!!!');
    FeatMap =[];
end

function [a]=LocalizePath(i);
a = regexp(i,'/');
a = ['/work2/FeatureMaps/' i(a(end-1)+1:end) ];
end
end
