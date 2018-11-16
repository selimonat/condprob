

for i = 65:128
    if i == 1;        
        fixmat = GetFixMat(S.p.FixmatInd);                
    end
    
    [S]=Saliency(PD{end-1},i);   
    smap = reshape(S.data(:,1),S.CurrentSize);
    %
    
    [fmap]=FixMat2FixMap(fixmat, S.p.kernel, S.CropAmount(1), S.ResizeFactor, 'image',i,'fix',2:100);
    
    
    figure(1)
    imagesc(reshape(S.data(:,1),S.CurrentSize))
    grid on
    figure(2)
    imagesc(fmap)
    drawnow
    r = corrcoef(fmap(:),S.data)
    title(mat2str(r(2,1)));
    grid on
    figure(3)
    im = Load_RGBImage(i);
    imagesc(im);
    grid on
    pause;
    
end