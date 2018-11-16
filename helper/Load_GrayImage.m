function [i]=Load_GrayImage(n)
%[i]=Load_Image(n)
%Loads Nth image or images within the vector N. Loaded images are used in
%Anke Walter's experiment. In case a vector is given images are stored
%along the 3rd dimension. The images are grayscale version of original
%images. To load RGB image use Load_RGBImage.
%
%Different categories differs in their index range
%1-64   :Natural
%65-128 :Fractal
%129-196:Urban
%197:255:Pinky
%
%22-May-2007 16:23:42, Selim.

t = length(n);
i = zeros(960,1280,t);
p = GetParameters;
%
%
c = 0;
for nn = n
    c = c +1;    
    file = sprintf([p.Base '/Stimuli/BMPs/image_%d.bmp'],nn);   
    i(:,:,c) = uint8(rgb2gray(imread(file)));
end

