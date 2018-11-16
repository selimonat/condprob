function ViewIM_S_FM(ii,PD)
%ViewIM_S_FM(ii,PD)
%
%
%Plots in a subplotthe image, the saliency map and the fixation map. The
%saliency map is computed from the input posterior distribution PD. II is
%the image index. In case it is a vector the subplot is extended.
%
%
%Selim, 28-Aug-2008 18:00:52

tii = length(ii);
%
figure('position',[0 0 1600 1200])
[suby,subx,w,h] = SubPlotCoor(3,tii);
%
counter = 0;
for ni =  ii;
    %
    counter = counter +1;
    %
    [SMAP,fixmap,s]=Load_SM_FixM(PD,ni);%load the SM and FixMap
    %
    im   = Load_RGBImage(ni);%load the stim and adjust the size to the SM
    im   = CropperCleaner(im,s.p.CropAmount);
    im   = imresize(im,1/s.p.bf);
    %
    ims  = size(im);
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    subplot('position' , [subx(1),suby(counter),w,h]);
    imagesc(im,[0 255])
    ylabel(mat2str(ni));
    c = [0 0 0];%axis color
    colormap gray
    grid on
    set(gca,'xtickLabel',[],'ytickLabel',[])
    set(gca,'xColor',c,'ycolor',c,'xColor',c,'ycolor',c,'xtick',ims(2)/2,'ytick',ims(1)/2)
    %
    axis image
    freezeColors
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    subplot('position' , [subx(2),suby(counter),w,h])
    imagesc(SMAP)
    if counter == 1
        title(cell2str(s.Feat,'###'),'interpreter','none')
    end
    colormap hot
    grid on
    c=[0.8 0.8 0.8];%axis color
    set(gca,'xtickLabel',[],'ytickLabel',[])
    set(gca,'xColor',c,'ycolor',c,'xColor',c,'ycolor',c,'xtick',ims(2)/2,'ytick',ims(1)/2)
    %
        axis image
    freezeColors
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    subplot('position' , [subx(3),suby(counter),w,h])
    imagesc(fixmap)    
    c = [0.8 0.8 0.8];
    colormap hot
    grid on
    set(gca,'grid',':','xtickLabel',[],'ytickLabel',[],'xColor',c,'ycolor',c,'xtick',ims(2)/2,'ytick',ims(1)/2)
    %
        axis image
    drawnow
end