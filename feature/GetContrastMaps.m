function GetContrastMaps(r,varargin)
%GetContrastMaps(r,varargin)
%GetContrastMaps(r,featurefolder1, featurefolder2)
%<
%
%R is the diameter of the circular patch.
%
%
%FEATUREFOLDER1, FEATUREFOLDER2 are different base features names... such as
%LUM, SAT, RG or YB. These could be different DKL Channels or their
%derivatives. These are stored in the $FeatureMaps folder. 
%
%This function computes the contrast maps of these base features. Any
%feature folder can be used as argument. For example using LUM (luminance
%channel) as an input to this function with a given R value, would return
%the luminance contrast maps with a name LUM_radius_R. If you use
%LUM_radius_R as an input argument then you would get something like         
%

p = GetParameters;
base = [p.Base 'FeatureMaps/'];


[patch]= CircularPatch(r);
patch  = patch./sum(patch(:));
totalimage = p.CondInd(end);
%
for n = 1:length(varargin);
	%
	BaseFeat = [base varargin{n}];
	%
	if exist(BaseFeat,'dir');%is there such a base feature.
		%create the new folder: after the base files will be
		%processed then they will be saved in this new folder.		
		savefolder = [BaseFeat '_C_Radius_' mat2str(r) '/']
		mkdir(savefolder);
		%run over all the images within the base 
		for ni = 1:totalimage;
			display([varargin{n} ': ' mat2str(ni./totalimage*100,2) '% finished...']);
			
			dummy = load(sprintf([BaseFeat '/image_%03d.mat'],ni));
			field = fieldnames(dummy);
			im    = dummy.(field{1});
			%in PAD we keep how much zeros we removed;
			[im pad] = CropperCleaner(im);
			
			[f] = ContrastMap2(im,patch,0,1);
            f = real(f);
			%we add back the removed zeros so that the final
			%maps has exactly the same size as the original
			%image.
			f = padarray(f,[pad pad]);
			%
			[savefolder sprintf('image_%03d.mat',ni) ]
			save([savefolder sprintf('image_%03d.mat',ni) ],'f');			
        end
	else
		display(['there is no such a base feature: ' varargin{n}]);
	end
end
