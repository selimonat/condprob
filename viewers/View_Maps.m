function View_Maps(folders,im)
%
%View_Maps(folders,im)
%
%Plots the maps of features given in the FOLDERS cell array for images IM.
%Each image is plotted in a separate figure, and all the instances of
%folders are plotted in differents subplots. The first image plotted will
%be the luminance channel.
%
%
%for example:
%ps_folders = ListFolders('~/pi/FeatureMaps/*PS*')
%im = [16 56];

for image = im
%
ps_folders= {'LUM' folders{:} };
%
t = length(ps_folders);
n = ceil(sqrt(t));
%
figure;
for i = 1:t   
    a = Images2FeatMap(['./' ps_folders{i}],image,0)
    subplot(n,n,i)
    imagesc(reshape(a.data,a.CurrentSize));
    drawnow    
    axis image
    set(gca,'xticklabel',[],'yticklabel',[])
    title(ps_folders{i},'interpreter','none','fontsize',8)
    if i == 1
        colormap gray
        freezeColors
    else
        colormap jet
        freezeColors
    end
end
end