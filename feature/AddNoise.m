function AddNoise(feat,varargin);
%AddNoise(feat,varargin);
%AddNoise(feat,CA);
%
%
%VARARGIN specifies the cropamount. Usually this is detected automatically
%but this poses some problems in the case of FIXMAP feature. The problem
%being that the estimation of the cropping amount (which is zero) yields
%non-zero and different results between images. That is why, for such
%features use VARARGIN to put explicitely CA to zero value.
%
%

if ~isempty(varargin)
    CA = varargin{1};
else
    CA = [];
end
display(['Cropping amount of ' mat2str(CA) ' is being used...'])
%base = ['~/pi/FeatureMaps/'];
base = ['/work2/FeatureMaps/'];
tf = length(feat)
for nf = 1:tf

	for ni = 1:255;
	[nf ni]
	%keyboard
	file = sprintf([base feat{nf} '/image_%03d.mat'],ni );	
	load(file);
	[f d]   = CropperCleaner(f,CA);
	u 	= unique(f);
	i       = find(u ~= 0 , 1);	
	s       = size(f);
	f       = f + rand(s(1),s(2))*u(i)/1000;
	f       = padarray(f,[d d]);

	save(file,'f');

	end

end
