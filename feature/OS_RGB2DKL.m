function [DKL] = OS_RGB2DKL(src);

% we can comment this out for the McGill images
src = double(src)/255;

% The measured gammas of the three guns rgb (Hitachi CM 772 ET monitor)
% From 30.May 2005 on we will use the Windows machine and the corresponding
% gammas
% gammas = [1.90998729918321; 1.97265979783937; 1.71397607085033];
% Due to change of monitor resolution on 22. July 2005 change in gamma.
% Only experiment color natural affected.
% The gamma for grayscale presentation is: 1.85765929979969
% gammas = [1.81331596443289; 1.87615724605704; 1.54251531858010];
% This gamma is for higher resolution of 1280x960
gammas = [1.995904322675231;2.084352553430287;2.022222679713093];

% The transformation matrix for arbitrary linear values between -m/2 and m/2 to DKL
% calculated for Samsung monitor in OS
GUN2DKL =  [   0.75365238939044  -0.57759533164323  -0.17605705774722; ...
              -0.30083307050033  -0.64082090026302   0.94165397076334; ...
               0.28259175305724   0.65480095253442   0.06260729440834];

% Take source image, correact for gamma and scale it to values between -0.5 and 0.5
Scal_RGB(:,:,1) = src(:,:,1).^gammas(1) - 0.5;
Scal_RGB(:,:,2) = src(:,:,2).^gammas(2) - 0.5;
Scal_RGB(:,:,3) = src(:,:,3).^gammas(3) - 0.5;

% The original image in DKL values
DKL(:,:,1) = (GUN2DKL(1,1)*Scal_RGB(:,:,1) + GUN2DKL(1,2)*Scal_RGB(:,:,2) + GUN2DKL(1,3)*Scal_RGB(:,:,3));
DKL(:,:,2) = (GUN2DKL(2,1)*Scal_RGB(:,:,1) + GUN2DKL(2,2)*Scal_RGB(:,:,2) + GUN2DKL(2,3)*Scal_RGB(:,:,3));
DKL(:,:,3) = (GUN2DKL(3,1)*Scal_RGB(:,:,1) + GUN2DKL(3,2)*Scal_RGB(:,:,2) + GUN2DKL(3,3)*Scal_RGB(:,:,3));