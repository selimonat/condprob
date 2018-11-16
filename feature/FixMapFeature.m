function FixMapFeature(FixmatInd,varargin)

fixmat = GetFixmat(FixmatInd);
p      = GetParameters;
%
folder = ...
[p.Base 'FeatureMaps/FixMap_FixmatInd_' mat2str(FixmatInd) '_FWHM_' mat2str(p.FWHM)];
mkdir(folder);

for x = 1:p.CondInd(end);
    
    ProgBar(x,p.CondInd(end));
    f        = fixmat2fixmap(fixmat,p.kernel,0,1,'www','image',x,varargin{:});
    filename = sprintf('image_%03d.mat',x)
    save([ folder '/' filename],'f');
    
end
