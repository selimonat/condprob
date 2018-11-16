function [mask]=GetZeroPadMask(size,ca)
%[mask]=GetZeroPadMask(size,ca)
%
%SIZE is the size of image
%CA is the crop amount
%mask is a binary mask with ones at the pixels which corresponds to zero
%pads.
%
%Selim, 13-Dec-2007 17:59:59




mask    = ones(size,'int8');
mask(ca+1:end-ca,ca+1:end-ca) = 0;
mask    = logical(mask);
