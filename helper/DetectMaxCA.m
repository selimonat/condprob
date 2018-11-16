%Use this script to detect the maximum Cropping Amount.
f = ListFolders('~/pi/FeatureMaps/*_*')

for i = 1:length(f)
    %
    fmap = Images2FeatMap( ['~/pi/FeatureMaps/' f{i} ] , 1 , []  );
    %
    data(i).feat = f{i};
    data(i).CA   = fmap.CropAmount;
    %    
end

plot(vertcat(data(:).CA),1:length(f),'o')
set(gca,'ytickLabel',f,'ytick',1:length(f))
grid on
title('CA for different Features')
xlabel('Cropping Amount (pixels)')