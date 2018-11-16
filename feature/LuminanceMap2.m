function [cim]=LuminanceMap2(im,kernel);
%[cim]=LuminanceMap2(im,kernel);
%this is basically the same as ContrastMap2.m. See ContrastMap.m for more
%information, the only difference is in line 20. Assumes that
%size(kernel,1) is equal to size(kernel,2).
ws = size(kernel,1);
if rem(ws,2)~=0

    imsize = [size(im,1) size(im,2)];
    %total images
    ti = size(im,3);
    %initialize the CIM
    %cim = zeros(imsize(1)-ws+1,imsize(2)-ws+1,ti);
    cim = zeros(imsize(1),imsize(2),ti);
    %compute the contrast map

    for n = 1:ti
        dummy      = conv2(im(:,:,n),kernel,'valid');
        cim(:,:,n) = padarray(dummy,[(ws-1)/2  (ws-1)/2 ]);
    end

else
    display(['choose a odd numbered window size']);
end

%convolution returns a matrix of size
%in case of full: a+m-1
%in case of same: a
%in case of valid: a-m+1
%so the difference of same-valid is m-1. if m is even number say 19, however you
%need to add 20 and 19 to the sides of the convolution matrix in order to
%get back to the same size which is prefered.
