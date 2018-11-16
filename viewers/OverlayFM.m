function OverlayFM(im,fm)
%OverlayFM(im,fm)
%
%Shows the image IM overlaid onto featuremap FM. This is done in two
%different ways.1/ With FM on top of the image in JET colors. Transparency
%of FM is proportional to FM value. 2/ The original image is mask with a
%transparency map. The transparency is high at position where FM is high.



%method one
figure;set(gcf,'position',[957    25   695   488])
Baseline = 0.1;%baseline opacity;
c = [colormap('gray') ;colormap('jet')];
%desaturate the image
desat(1,1,:) = [1 0 1];
im = hsv2rgb(repmat(desat,[size(im,1) size(im,2) 1]).*rgb2hsv(im));
imagesc(im);
set(gca,'CLim',[0 1]);
hold on;
h =imagesc(Scale(fm)/2+0.5);
set(h,'alphadata',Scale(fm)*(1-Baseline)+Baseline);
colormap(c);
hold off
axis off
set(gca,'position',[0 0 1 1]);
set(gcf,'menubar','none')
%method two:
% % figure(2)
% % h = imagesc(im);
% % set(h,'alphadata',Scale(fm)*(1-Baseline)+Baseline);
% % axis off
% % set(gca,'position',[0 0 1 1]);
% % set(gcf,'menubar','none')