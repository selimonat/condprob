function [res]=IOV_ver3(fixmat,bf,nbs,varargin)
%fixmat can be filtered with varargin arguments which are fed to SelectFix
%function
%%%HERE IN A SIMILAR WAY I QUANTIFY THE CORRELATION BETWEEN FIXATION MAPS
%%%WHICH ARE CONSTRUCTED WITH RANDOMLY SELECTED FIXATION DATA... I CREATE
%%%NBS FIXATION MAPS BY NOT RESPECTING THE FIXATIONS' IMAGE BELONGANCE
%
%%same as previous version but here we subtract from the maps the average .
%%so that we remove what is common from all the maps.
%
imsize_ori   = [fixmat.rect(2) fixmat.rect(4)];
imsize_bin   = imsize_ori./bf;
reso         = 200;%the number of bins to make the histogram of the correlation coeff.
res.binedges = linspace(-1,1,reso);%Bin edges of the R hist.
%
%clean the fixmat from unwanted fixations
display(repmat('-',1,100));
display([mfilename ': cleaning the fixmat according to varargin']);
fixmat     = SelectFix(fixmat,varargin{:});
%
im         = unique(fixmat.image);
tim        = length(im);
c          = 0;
%init the storage variable for maps.
MAP        = zeros( imsize_bin(1)*imsize_bin(2) , nbs );
MAP_C      = zeros( imsize_bin(1)*imsize_bin(2) , nbs );
%
%for each of the condition we create one map which is the average over all
%the 
for cond = 1:4
x             = ceil(fixmat.x( fixmat.condition == cond )./bf);
y             = ceil(fixmat.y( fixmat.condition == cond )./bf);
dummy         = accumarray( [y(:) x(:)] , 1 , imsize_bin );
ave(:,:,cond) = dummy./sum(dummy(:));
end
%
x_all      = ceil(fixmat.x./bf);
y_all      = ceil(fixmat.y./bf);
%
for i = im;   
    %
    c = c+1;
    display('-');
    display([mfilename ': image ' mat2str(c) ' of ' mat2str(tim)]);
    %this is our bucket of fixation done on the image I. It has a total of
    %tFIX fixations      
    x    = ceil(fixmat.x( fixmat.image == i )./bf);
    y    = ceil(fixmat.y( fixmat.image == i )./bf);
    %
    tfix = length(x);
    %
    %we enter to the bootstraping cycles
    display([mfilename ': bootstraping...']);
    tic;
    for n = 1:nbs
        %%ACTUAL COMPARISON
        %
        %we select TFIX fixation WITH REPLACEMENT from our bucket.
        x2  = randsample(x,tfix,1);
        y2  = randsample(y,tfix,1);
        %
        map = accumarray([y2(:) x2(:)],1,imsize_bin);
        %remove the average map from the current map for this we need to
        %remove the average of the category
        %
        map = map - ave(:,:,ceil(255./64));
        %
        MAP(:,n)   = map(:);        
        %CONTROL COMPARISON
        %same as just above
        x2         = randsample(x_all,tfix,1);
        y2         = randsample(y_all,tfix,1);
        map_c      = accumarray([y2(:) x2(:)],1,imsize_bin);
        map_c      = map_c - ave(:,:,ceil(255./64));
        MAP_C(:,n) = map_c(:);
    end      
    display([mfilename ': bootstraping finished in ' mat2str(toc) ' s.']);
    %now we evaluate the similarity by computing the correlation
    %coeffecient between each and every map. this 
    display([mfilename ': computing the correlation and histograms']);
    tic
    r   = corrcoef(MAP);%actual
    r_c = corrcoef(MAP_C);%control
    %extract one of the halves...
    ind = triu(logical(ones(size(r))),1);
    r   = r(ind(:));%actual
    r_c = r_c(ind(:));%control
    %instead of storing all the values we store the counts as integer
    %values.
    %actual
    [dummy]         = histc( r , res.binedges );
    res.count(:,i)  = uint64(dummy(:));
    %control 
    [dummy]         = histc( r_c , res.binedges );
    res.count_c(:,i)= uint64(dummy(:));
    %
    display([mfilename ': finished in ' mat2str(toc) 's.'])    
end
WP  = ['/home/staff/s/sonat/project_Integration/IOV/' mfilename '_BF_' mat2str(bf) '_NBS_' mat2str(nbs) ];
save(WP,'res');
