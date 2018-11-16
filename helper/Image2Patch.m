function [p]=Image2Patch(im,ps)
%[p]=Image2Patch(im,ps)
%
%
%This function transforms and image IM into a set of non-overlapping
%patches with size PS. The number of patches are loaded to the 4th
%dimension of P and the 3rd dimension is kept for color channels.
%
%
%Selim, 31-Oct-2007 16:01:38

s      = size(im);
s(3)   = size(im,3);
%
y = 1:ps:s(1)-ps;
x = 1:ps:s(2)-ps;
%
display([mfilename ': transforming the image into a set of patches.'])
%
c = 0;
%
for nx = 1:length(x)
    for ny = 1:length(y)
        %
        c        = c +1;
        for ndimen = 1:s(3)
p(:,:,ndimen,c) = im( y(ny):y(ny)+ps-1 , x(nx):x(nx)+ps-1 , ndimen );
        end
        %
    end
end




