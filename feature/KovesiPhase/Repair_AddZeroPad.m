factor = 3.5;%this factor seems to be enough to eliminate the artefactual zones.
imgs = 1:255;
feat = ListFolders('~/pi/FeatureMaps/*IntDim*')

for nf = 9:length(feat)

    data = Images2FeatMap( ['~/pi/FeatureMaps/' feat{nf} ] , imgs, 0  );                

    ii = regexp(data.Path,'_');
    CA  = ceil(str2num(data.Path(ii(end)+1:end)).*factor);

    CA
    data.Path
    
    mask = GetZeroPadMask(data.CurrentSize,CA);
    
    data.data(mask(:),:) = 0;
    
    for i = 1:255    
        f = reshape(data.data(:,i),data.CurrentSize);        
        save(sprintf(['/work2/FeatureMaps/' feat{nf} '/image_%03d.mat'],i),'f')                               
        %need to sync with the server afterward
    end
    clear data
    
end
