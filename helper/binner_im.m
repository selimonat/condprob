function [im]=binner_im(im,kernel)
%[im]=binner_im(im,kernel)
%
%   Resizes an image without applying any complicated ass-stretched
%   algorithms. Simply it takes the average value with in non-overlapping
%   parts of an image. The size of the relevant image part is determined by
%   the size of the kernel. To resize an image by X use as kernel this
%   variable: ones(X)/X^2. Optionnaly if you prefer not to take the average
%   but simply sum, then dont divide it X^2.
%
%
%   Selim, 08-Feb-2008 13:15:10

BF    = size(kernel,1);
im    = conv2(im,kernel,'valid');%make a convolution
im    = im(1     :BF:end,1:BF:end);%take each nonoverlapping point
