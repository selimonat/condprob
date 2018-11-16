function ViewImFixMap(feat,ni);
%ViewImFixMap(feat,ni);
%Shows in a subplot NIth image, its fixation map and its features maps.
%FEAT is the feature list and NI is the image you want to visualize its
%fixation map and feature maps. FEAT must be a cell array of 6 entries.
%
%Use All_ViewImFixMap to run over the entire database and save the results
%as pngs.
%A list of precomputed subplots can be found in $/Stimuli/ImFixMaps
%
%
%Selim, 31-May-2007 16:03:19

%

if length(feat) == 6;
fixmat = GetFixMat(1);
%
p      = GetParameters;
base     = '/mnt/sonat/project_Integration/FeatureMaps/';
basepost = '/mnt/sonat/project_Integration/PostDist/1D/';
cate     = ceil(ni./64);
%
tf = length(feat);
%
imRGB  = Load_RGBImage(ni);
fixmap = fixmat2fixmap( fixmat , p.kernel , 0 , 'image' , ni, 'fix',2:1000);
%
for nf = 1:tf
    fmap       = Images2FeatMap([ base feat{nf} ] , ni);
    %
    dummy      = reshape(fmap.data,fmap.CurrentSize);
    dummy2     = repmat(NaN,fmap.OriginalSize);
    ca         = fmap.ZeroPadAmountinOriginal;
    dummy2(ca+1:end-ca,ca+1:end-ca) = dummy;
    im(:,:,nf) = dummy2;
    %
    %Get post distributions    
    ff = ListFiles([basepost 'Feat_' feat{nf} '_nCat_' mat2str(cate) '*']);
    ff{1}
    post(nf) = load([basepost ff{1}]);
    
end


%
figure('position',[0 0 1600 1200]);
opt = {'FontWeight','bold','FontSize',15,'color','r','interpreter','none'};
x   = linspace(1280,0,20);
ni  = mod(ni-1,64)+1
for n = 1:size(im,3)+2;
%   subplot(ceil( sqrt(tf+1)),ceil( sqrt(tf+1)),n);
%	subplot('position,[left bottom w h]);
    if n == 1           	
    	subplot('position',[0 0.5 0.5 0.5])
        subimage(imRGB);
 a
        
    elseif n == 2
       	subplot('position',[0.5 0.5 0.5 0.5])
        imagesc(Scale(double(fixmap)));
        colormap hot
a
    elseif n == 3
        subplot('position',[0 0.25 0.25 0.25])
        imit;
        hold on
        plot(x,post(n-2).res.C.Raw(:,ni)./0.1*960,'g');
plot(fliplr(x),-(fliplr(post(n-2).res.A.Raw(:,ni)./0.1*960-480))+480,'k','linewidth',3);
    	title(feat{n-2},opt{:})
        a
    elseif n == 4
        subplot('position',[0 0 0.25 0.25])
        imit;
        plot(x,post(n-2).res.C.Raw(:,ni)./0.1*960,'g');
plot(fliplr(x),-(fliplr(post(n-2).res.A.Raw(:,ni)./0.1*960-480))+480,'k','linewidth',3);
    	title(feat{n-2},opt{:})
       a
    elseif n == 6
        subplot('position',[0.3 0 0.25 0.25])
        imit;
        plot(x,post(n-2).res.C.Raw(:,ni)./0.1*960,'g');
plot(fliplr(x),-(fliplr(post(n-2).res.A.Raw(:,ni)./0.1*960-480))+480,'k','linewidth',3);
    	title(feat{n-2},opt{:})
      a
    elseif n == 5
        subplot('position',[0.3 0.25 0.25 0.25])
        imit;
        plot(x,post(n-2).res.C.Raw(:,ni)./0.1*960,'g');
plot(fliplr(x),-(fliplr(post(n-2).res.A.Raw(:,ni)./0.1*960-480))+480,'k','linewidth',3);
    	title(feat{n-2},opt{:})
     a
    elseif n == 8
        subplot('position',[0.6 0 0.25 0.25])
        imit;
        plot(x,post(n-2).res.C.Raw(:,ni)./0.1*960,'g');
plot(fliplr(x),-(fliplr(post(n-2).res.A.Raw(:,ni)./0.1*960-480))+480,'k','linewidth',3);
    	title(feat{n-2},opt{:})
    a
    elseif n == 7
        subplot('position',[0.6 0.25 0.25 0.25])
        imit;
        plot(x,post(n-2).res.C.Raw(:,ni)./0.1*960,'g');
plot(fliplr(x),-(fliplr(post(n-2).res.A.Raw(:,ni)./0.1*960-480))+480,'k','linewidth',3);
    	title(feat{n-2},opt{:})
a

    end
    %axis off
    drawnow;
end
else
display('ERROR: feat must have 6 features');
end
function a
set(gca,'xticklabel',[],'yticklabel',[],'ytick',linspace(0,960,5),'xtick',linspace(0,1280,5),'xgrid','on','xcolor',[1 1 1],'linewidth',3,'ygrid','on','ycolor',[1 1 1]);
end
    function imit
        aa = im(:,:,n-2);
        [aa shit]= CropperCleaner(aa);
        [ali veli] = histc(aa,post(n-2).res.be.data(:,ni));
        veli = padarray(veli,[shit shit]);
        veli = veli./20;
        imagesc(veli);
        colormap jet
        hold on
    end
end