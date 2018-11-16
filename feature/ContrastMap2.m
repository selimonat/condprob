function [cim]=ContrastMap2(im,kernel,Normalize,Pad);
%[cim]=ContrastMap2(im,ws,Normalize,Pad);
%
%The difference to ContrastMap is that in this function we provide the
%kernel as an input. Therefore we have the option to choose any kernel
%shape. Before we were obliged to use a square kernel.
%
%It computes the contrast map of a given image IM by using a kernel
%specified in KERNEL. KERNEL must have a sum of equal to 1 and in addition
%to this it has to have a odd numbered size. Assumes that kernel is square.
%
%IM can contain many different images in its 3rd dimension then CIM 
%contains the contrast maps of the corresponding images in its third dimension.
%It uses convolution routines of matlab. 
%
%NORMALIZE has to be 1 if you want to normalize the contrast map
%by the mean luminance of the image. 
%
%if PAD is 1 it zero pads the image so that the contrast map and the image
%have the same size.
%
%Selim, 01-Jun-2007 15:55:04

%
ws = size(kernel,1);
%
%if the kernel is odd numbered AND has unit integral. 
if rem(ws,2)~=0 

    imsize = [size(im,1) size(im,2)];
    %total images
    ti = size(im,3);
    %initialize the CIM    
    
    if Pad == 1
        cim = zeros(imsize(1),imsize(2),ti);
    else
        cim = zeros(imsize(1)-ws+1,imsize(2)-ws+1,ti);            
    end


    for n = 1:ti
        if Normalize == 1
            dummy = (sqrt(conv2(sum(kernel),sum(kernel,2),im(:,:,n).^2,'valid') - conv2(sum(kernel),sum(kernel,2),im(:,:,n),'valid').^2))./mean2(im(:,:,n));
            if Pad == 1
                cim(:,:,n) = padarray(dummy,[(ws-1)/2  (ws-1)/2 ]);
            else
                cim(:,:,n) = dummy;
            end
        elseif Normalize == 0
            dummy = (sqrt(conv2(sum(kernel),sum(kernel,2),im(:,:,n).^2,'valid') - conv2(sum(kernel),sum(kernel,2),im(:,:,n),'valid').^2));
            if Pad == 1
                cim(:,:,n) = padarray(dummy,[(ws-1)/2  (ws-1)/2 ]);
            else
                cim(:,:,n) = dummy;
            end
        else
            display('[cim]=ContrastMap(im,ws,Normalize); Normalize has be equal to 1 or 0.');
        end
    end

else
    display(['choose a odd numbered window size | sum(kernel(:)) must be 1!']);
    cim = [];
end
