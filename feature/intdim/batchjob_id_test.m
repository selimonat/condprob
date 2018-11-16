function batchjob_id_test(stddev_);
%robert's original values: [5 10 23 45 91]
%creates a random image and computes the intrinsic dimensionality features.
%the resulting feature maps are used to evaluated the extent of edge and
%corner artefacts.

WritePath = '~/project_Integration/test_PS/'
%
stddev_pre = 3;
gSz_pre    = round(2.65*2.355*stddev_pre);
%
for ni = 1
    im = rand(960,1280);
	C = 0;
    for stddev     = stddev_;
		C = C+1;
        %CREATE THE FOLDERS
        if ni == 1
            mkdir([WritePath]);
        end
        fwhm            = 2.355*stddev;
        gSz             = round(2.65*fwhm);
        display(['calling tensor'])
        [t,c]           = tensor(im,[gSz,stddev],[gSz_pre,stddev_pre]);
        display(['calling tc2id'])
        [i2d, i1d, i0d] = tc2id(t,c);
        display(['saving'])
        %STORE THE IMAGES
	 for dim = 0:2
            eval(['f = i' mat2str(dim) 'd;']);
            save(sprintf([WritePath  'IntDim_%01d_StdDev_%02d.mat'],dim,stddev),'f')
        end
    end
end



