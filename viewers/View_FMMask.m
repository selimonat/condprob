function View_FMMask(feat,imgs)
%View_FMMask(feat,imageindex)
%
% Overlays the FM on top of the image which it corresponds to and saves the
% results in a folder $/View_FMMask/FEATURENAME/imageXXX.jpg
%
%
%Selim, 01-Oct-2008 16:06:02


tfeat = length(feat);
%
p     = GetParameters;
path_ = p.Base;
%
for nf = 1:tfeat
    %
    Folder = [path_ mfilename '/' feat{nf} '/']
    %Folder = [path_  feat{nf} '/']
    if exist(path) == 0 
    mkdir(Folder);
    end
	%
	ProgBar(nf,tfeat)

    for i = imgs;
    	%        
		WritePath{1} = sprintf([Folder feat{nf} '_image%03d_heatmap.png'],i);
		WritePath{2} = sprintf([Folder feat{nf} '_image%03d_alphamap.png'],i);
		%if ~exist(WritePath{1});

        display([ 'Feature: ' Folder ': Image ' mat2str(i) ': being computed.'])
            
		a   = Images2FeatMap(['~/pi/FeatureMaps/' feat{nf}],i,0);
        %
        fm  = reshape(a.data(:,1),a.CurrentSize);
        %
        im = Load_RGBImage(i);
        %
		OverlayFM(im,fm);
		%put the figure to the primary monitor otherwise transparencies can
		%not be saved somehow i.e. stupid matlab!
		for nfig = 1:2
			pos = get(nfig,'position');
			set(nfig,'position',[1680 pos(2:4)])
       		 %                     
            set(nfig,'renderer','opengl')			
            exportfig(nfig,[ WritePath{nfig} ],'format','png','Bounds','loose','color','rgb');
        	
			set(nfig,'renderer','painters')
            close(nfig)
         end
        close all
        %
		%else
		%	display([ 'Image ' mat2str(i) ': Already computed...'])
		%end
    end
end
