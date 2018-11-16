
fixmat_r = GetFixMat(1);%real fixmat
%%texture map saliency map

filename = '1Dimen_LUM_C_Radius_45_Im_[65:128]_nBS_0_FWHM_45_CropAmount_[]_nBin_20_start_0_end_6500_fixs_2_fixe_1000_subjects_[1:25]_FixmatInd_1_pooled_0.mat'
S = Saliency(filename);
%%load sythn fixmat
load(['SyntFixMats/fixmat_tsub_25_tfix_20_' filename ]);
%%

for im = 65:128

    figure(1);
    imagesc(binner_2D(fixmat2fixmap(fixmat,1,0,'image',im,'fix',1:10000),64));;

    figure(2);
    imagesc(binner_2D(reshape(S.data(:,im-65),S.OriginalSize),64))

    figure(3);
    imagesc(binner_2D(fixmat2fixmap(fixmat_r,1,0,'image',im,'fix',1:10000),64));;

    figure(4);
    im = imread(['Stimuli/BMPs_SmallSize/image_' mat2str(im) '.bmp']);
    imagesc(binner_2D_RGB(im,32)./255)
    figure(5)
    imagesc(im)
    %
    drawnow
    pause
end