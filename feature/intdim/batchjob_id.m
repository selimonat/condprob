function batchjob_id(stddev_);
%robert's original values: [5 10 23 45 91]

p = GetParameters;
WritePath = [p.Base 'FeatureMaps/'];
totalimage = p.CondInd(end);
%
stddev_pre = 3;
gSz_pre    = round(2.65*2.355*stddev_pre);
%
for ni = 1:totalimage
    display(mat2str(ni./32*100));
    ff = Images2FeatMap([p.Base 'FeatureMaps/LUM'],ni);
	C = 0;
    for stddev     = stddev_;
		C = C+1;
        %CREATE THE FODLERS
        if ni == 1
            for dim = 0:2
                name{C,dim+1} = ['LUM_IntDim_' mat2str(dim) '_prestd_' mat2str(stddev_pre) '_std_' mat2str(stddev)];
                mkdir([WritePath  name{C,dim+1}]);
            end
        end
        fwhm            = 2.355*stddev;
        gSz             = round(2.65*fwhm);
        display(['calling tensor'])
        [t,c]           = tensor(reshape(ff.data,ff.CurrentSize),[gSz,stddev],[gSz_pre,stddev_pre]);
        display(['calling tc2id'])
        [i2d, i1d, i0d] = tc2id(t,c);
        
        %add zeros to remove the artefactual places
        mask = GetZeroPadMask(ff.OriginalSize,round(stddev*3.51));%a factor of 3.5 is necessary
        i2d(mask(:)) = 0;
        i1d(mask(:)) = 0;
        i0d(mask(:)) = 0;
        
        display(['saving'])
        %STORE THE IMAGES
	 for dim = 0:2
            eval(['f = i' mat2str(dim) 'd;']);
            save(sprintf([WritePath name{C,dim+1} '/image_%03d.mat'],ni),'f')
        end
    end
end




