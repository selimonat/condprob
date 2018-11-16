
%values alper used: 3:7:17
minWaveLength_ = 3:7:17
sigmaons = [.65 .55];
mults    = [2.1  3];
savepath = '~/project_Integration/Test_PS/';

for nscale = 5:7
    for minWaveLength = minWaveLength_;
        for SigMul = 1:2
            sigmaOnf = sigmaons(SigMul);
            mult = mults(SigMul);
            foldername = strcat('LUM_PS_', 'minWL', mat2str(minWaveLength)...
                , '_nSc', mat2str(nscale), '_mult', mat2str(mult));
            
            tosave = [savepath foldername ];
            
            for ims = 1;
                tic
                im = rand(960,1280);
                f = phasesym(im, nscale, 6, minWaveLength, mult, sigmaOnf, 1.2, 2);
                save([tosave '.mat'], 'f')
                clear PhaseSym
                toc
            end
        end
    end
end