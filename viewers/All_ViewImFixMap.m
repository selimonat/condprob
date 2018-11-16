function All_ViewImFixMap(f,pre)
%All_ViewImFixMap(f,pre);
%F is the feature list; It is a loop over all the images. It calls
%ViewImFixMap and save the subplot as an PNG image in a folder. PRE is add
%to the file name before the image index.
%
%Selim, 31-May-2007 16:05:16




SaveBase = '/home/staff/s/sonat/sonat/project_Integration/Stimuli/ImFixMaps/';

for n = 1:255;
    %
    WritePath = sprintf( [ SaveBase pre '_image_%03d' ] , n );
    %
    ViewImFixMap(f,n);
    %
    display('saving');
    display(WritePath);
    %exportfig(gcf,[WritePath '.png'],'format','png','FontSizeMin',15,'Bounds','loose');
    exportfig(gcf,[WritePath '.jpg'],'format','jpeg80','FontSizeMin',15,'Bounds','loose');
    %
    close all;
end
