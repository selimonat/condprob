factor = 1./2;%this factor seems to be enough to eliminate the artefactual zones.
imgs = 1:255;
feat = ListFolders('~/pi/FeatureMaps/*_PC_*')

for nf = 1:length(feat)

    data = Images2FeatMap( ['~/pi/FeatureMaps/' feat{nf} ] , imgs, 0  );
    if nf == 1 | nf == 9
        CA = 60
    else
        ii  = regexp(data.Path,'_');
        CA  = ceil(str2num(data.Path(ii(end)+1:end)).*factor);
    end
    %
    mask = GetZeroPadMask(data.CurrentSize,CA);    
    data.data(mask(:),:) = 0;
    %
    for i = 1:255    
        i
        f = reshape(data.data(:,i),data.CurrentSize);        
        save(sprintf(['/work2/FeatureMaps/' feat{nf} '/image_%03d.mat'],i),'f')                               
        %need to sync with the server afterward
    end
    clear data
    
end
