% Requires the path to Selim's Images2FeatMap.

WritePath = '/mnt/rmaertin/fix/feat/derivatives/';
addpath(genpath('/mnt/rmaertin/fix/nbp/eyetracking/condprob/'));
for stddev     = [3 5 10 23 45];
    fwhm            = 2.355*stddev;
    gSz             = round(2.65*fwhm);
    g=(fspecial('gaussian',gSz,23));
    borderSize      = floor(gSz)./2);
    [l,dx,dy]=derivative(g);
    for ni = 1:255
        display(mat2str(ni./255*100));
        ff = Images2FeatMap('/mnt/sonat/project_Integration/FeatureMaps/LUM',ni);
        ff=reshape(ff.data,ff.OriginalSize);
        display(['computing dx'])
        f = imfilter(ff,dx,'conv','same');
        newF = zeros(size(f));
        newF(borderSize+1:end-borderSize,borderSize+1:end-borderSize,:) = ...
            f(borderSize+1:end-borderSize,borderSize+1:end-borderSize,:);
        f = newF;
        save(sprintf([WritePath 'LUM_DX_STD_' num2str(stddev) '/image_%03d.mat'],ni),'f');

        display(['computing dy'])
        f = imfilter(ff,dy,'conv','same');
        newF = zeros(size(f));
        newF(borderSize+1:end-borderSize,borderSize+1:end-borderSize,:) = ...
            f(borderSize+1:end-borderSize,borderSize+1:end-borderSize,:);
        f = newF;
        save(sprintf([WritePath 'LUM_DY_STD_' num2str(stddev) '/image_%03d.mat'],ni),'f');

        display(['computing laplacian'])
        f = imfilter(ff,l,'conv','same');
        newF = zeros(size(f));
        newF(borderSize+1:end-borderSize,borderSize+1:end-borderSize,:) = ...
            f(borderSize+1:end-borderSize,borderSize+1:end-borderSize,:);
        f = newF;
        save(sprintf([WritePath 'LUM_LAP_STD_' num2str(stddev) '/image_%03d.mat'],ni),'f');
    end
end




