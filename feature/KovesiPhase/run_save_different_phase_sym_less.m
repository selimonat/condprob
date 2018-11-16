images = dir('~/project_Integration/FeatureMaps/LUM/*.mat');
readpath = '~/project_Integration/FeatureMaps/LUM/';

savepath = '~/pi/FeatureMaps/';


minWaveLength = 12;
mult = 2;
nscale = 2;


foldername = strcat('LUM_PS_', 'minWL', mat2str(minWaveLength)...
    , '_nSc', mat2str(nscale), '_mult', mat2str(mult));

if ~exist([savepath foldername], 'dir')
    evalstring = ['!mkdir ', savepath, foldername];
    eval(evalstring);
end

tosave = [savepath foldername '/'];

for ims = 4:length(images)
    tic
    load([readpath images(ims).name])
    im = f; clear f;
    f = phasesym(im, nscale, 6, minWaveLength, mult);
    save([tosave sprintf('image_%03d', ims) '.mat'], 'f')
    clear PhaseSym
    toc
end
