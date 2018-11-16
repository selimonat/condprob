function [m]=FMapEntVSFeatEnt(f,imgs,FixmatIndex);
%[m]=FMapEntVSFeatEnt(f,imgs,FixmatIndex);
%[m]=FMapEntVSFeatEnt(features,Images,FixmatIndex);

p      = GetParameters;
fixmat = GetFixMat(FixmatIndex);
tf     = 1:length(f);


for nf = tf;
    fmap      = Images2FeatMap(['/mnt/sonat/project_Integration/FeatureMaps/' f{nf} '/' ] ,imgs,[],2);
    %add a constant value so that there are no negative values.
    fmap.data = fmap.data + repmat( abs(min(fmap.data)) , size(fmap.data,1) , 1 );
    %add a machine epsilon so that there are no zeros
    fmap.data = fmap.data + eps;
    %make it a probability distribution.
    fmap.data = fmap.data./repmat(sum(fmap.data),size(fmap.data,1),1);    

    %As the cropping amount changes For each of the featuremaps we
    %recompute the fixation maps accordingly. 
    m(nf).feature  =  f{nf};
    ProgBar(nf,tf)
    counter = 0;    
    for i = imgs    
        counter = counter + 1;

        %get the fixation map with the current crop amount
        map         = fixmat2fixmap(fixmat,p.kernel,fmap.CropAmount,2,'image',i,'fix',2:1000);
        %get the size
        m(nf).size      = size(map);
        %get the its entropy
        dummy = -(map(:)'+eps)*log2(map(:)+eps);    
        m(nf).ent_fix(counter) = dummy;
        %in the same time get the entropy of the feature map.
        dummy = -(fmap.data(:,counter)'+eps)*log2(fmap.data(:,counter)+eps);
        m(nf).ent_feat(counter) = dummy;
        %display some results
        figure(1);
        plot([m(nf).ent_feat(:) m(nf).ent_fix(:) ],'o-')       
        
        drawnow
    end    
    clear fmap
end
