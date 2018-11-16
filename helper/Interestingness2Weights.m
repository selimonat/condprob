
%this is used to create the WCLICK field of the baseline fixmat (niklas and torsten's)
fixmat.Wclick  = ones(1,length(fixmat.x));

for im = 1:192
    %load the image. one at a time
    fmap = Images2FeatMap('~/pi/FeatureMaps/ClickMap_FWHM_45',im);
    %take the indices of fixations correcponding to the current image
    i = fixmat.image == im;
    %coordinates of the fixations linearized
    coor = sub2ind(fmap.CurrentSize,round(fixmat.y(i)'),round(fixmat.x(i)'));
    %take the inverse of interestingness values after scaling
    fmap.data = (Scale(fmap.data(:,1))*-1+1).^20;
    
    fixmat.Wclick(i) = fmap.data(coor).^2;
end
    
