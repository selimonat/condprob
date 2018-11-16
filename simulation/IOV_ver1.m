function FixMapSimilarity(fixmat,gau,cropamount,binning,image,varargin)



for i = image;

    %first we create all the fixation maps that are produced by all
    %subjects for a given image I. We bin all the maps with a given binning
    %factor after removing the edges.
    for s = unique(fixmat.subject);
        
    
        map = fixmat2fixmap(fixmat,gau,cropamount,'image',i,'subject',s,varargin{:});
    
        map = binner_2D(map,binning);
        MAP(:,s) = map(:);   
        %we compute the correlation coeffecient for all possible pairs of maps.    
        r = corrcoef(MAP);
    end
end







