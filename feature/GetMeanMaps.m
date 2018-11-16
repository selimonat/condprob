function GetMeanMaps(r,varargin)

p = GetParameters;
base = [p.Base 'FeatureMaps/'];

[patch]=CircularPatch(r);
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
		savefolder = [BaseFeat '_M_Radius_' mat2str(r) '/']
		mkdir(savefolder);
		%run over all the images within the base 
		for ni = 1:totalimage;
			display([varargin{n} ': ' mat2str(ni./totalimage*100,2) '% finished...']);
			dummy = load(sprintf([BaseFeat '/image_%03d.mat'],ni));
			field = fieldnames(dummy);
			im = dummy.(field{1});
			[f] = LuminanceMap2(im,patch);
			[savefolder sprintf('image_%03d.mat',ni) ]
			save([savefolder sprintf('image_%03d.mat',ni) ],'f');
			
		end

	
	else
		display(['there is no such a base feature: ' varargin{n}]);
	end
end
