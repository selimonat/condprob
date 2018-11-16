function run_save_different_phase_sym(minWaveLength_)
%values alper used: 3:7:17

images   = dir('~/project_Integration/FeatureMaps/LUM/*.mat');
readpath = '~/project_Integration/FeatureMaps/LUM/';
sigmaons = [.65 .55];
mults    = [2.1  3];
savepath = '~/project_Integration/FeatureMaps/';
for nscale = 5:7

    for minWaveLength = minWaveLength_;
        for SigMul = 1:2
            sigmaOnf = sigmaons(SigMul);
            mult = mults(SigMul);
            foldername = strcat('LUM_PS_', 'minWL', mat2str(minWaveLength)...
                , '_nSc', mat2str(nscale), '_mult', mat2str(mult));
            
            if ~exist([savepath foldername], 'dir')
                evalstring = ['!mkdir ', savepath, foldername];
                eval(evalstring);
            end
            tosave = [savepath foldername '/'];
            
            for ims = 1:length(images);
                tic
                load([readpath images(ims).name])
                im = f; clear f;
                f = phasesym(im, nscale, 6, minWaveLength, mult, sigmaOnf, 1.2, 2);
                save([tosave sprintf('image_%03d', ims) '.mat'], 'f')
                clear PhaseSym
                toc
            end
        end
    end
end