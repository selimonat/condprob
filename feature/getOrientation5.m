function  [angle, excentr, CoM] = getOrientation5(img, fwhm);
%
%% call function [angle, excentr, CoM] = getOrientation4(img, fwhm);
%
% calculates the main orientation inside an image
% details of method: [Jaehne 1997] p.382ff
% note: if J_xx > J_yy correction of pi/2 neccessary
%       (wrong branch of tangent otherwise)
% 
% OUT  
%  angle:   orientaion (0<angle<pi)
%  excentr: between 0 and 1, 0 = circle, 1 = line
%  pos:     position of CoM of bar
%
% IN 
%  img: a grayscale image
%
% last update: 07/06/04 fschuman,weinhaeu
%              02/10/10 weinhaeu
%              00/09/21 weinhaeu
%              00/10/15 weinhaeu  
%              
%


% filters for derivatives in x and y direction
% [-1 0 1] or simple Sobel would lead to big (up to 7 deg) 
% error in orientation estimation 
 
%G= ones(fwhm)./sum(sum(ones(fwhm))); % mean kernel
%G = makeKernel(fwhm);
ws=ceil(2.7*fwhm); % windowsize

G=make_gaussian(ws, ws, fwhm, fwhm, ceil(ws/2), ceil(ws/2));
G=G ./ sum(sum(G));

img = double(img-mean(img(:)));

imgSize = size(img);

%optimized Sobel-operator
D_x = 1/32*[3 0 -3; 10 0 -10; 3 0 -3];
D_y = 1/32*[3 10 3; 0 0 0; -3 -10 -3];

%BinF = 1/16*[1,2,1;2,4,2;1,2,1];
D_xImg = conv2(img, D_x);                % gradients in x und y
D_yImg = conv2(img, D_y);

tmpXX = D_yImg.^2;                      % get rid of signs
tmpYY = D_xImg.^2; 
tmpXY = D_xImg.*D_yImg;                  

%tmp2XX = conv2(BinF,tmpXX);
%tmp2YY = conv2(BinF,tmpYY);
%tmp2XY = conv2(BinF,tmpXY);

% old: local integration of gradients by summing, img is a local patch
%f J_xx = sum(tmpXX(:));                  % we need local integration that can
%f J_yy = sum(tmpYY(:));                  % be done with convolution, so here
%f J_xy = sum(tmpXY(:));                  % we do a meanfilter instead of sum.

% new: local integration with mean filter, img is the entire image
J_xx = real(conv2(tmpXX,G,'same'));
J_yy = real(conv2(tmpYY,G,'same'));
J_xy = real(conv2(tmpXY,G,'same'));


if (J_xx==J_yy)
  warning('empty / isotrop patch in getOrientaion');
  excentr = 0;
  angle = NaN;
  CoM = [NaN; NaN];
else
  %claculate angle eigenvalues, etc.
  if (J_yy < J_xx)
	angle = 0.5.*atan(2.*J_xy./(J_yy-J_xx));
  else
	angle = 0.5*atan(2*J_xy./(J_yy-J_xx))+pi./2;
  end
  
  angle = angle + (angle < 0)*pi;
  
  
  excentr = ((J_yy-J_xx).^2+4.*J_xy.^2)./(J_xx+J_yy).^2;
  
  %calculate gradient in direction of angle 
  grad = (D_xImg.*cos(angle)).^2+(D_yImg.*sin(angle)).^2; 
  

  
  %max of gradient
  A = ((1:imgSize(1))'*ones(1,imgSize(2))).*grad(2:size(grad,1)-1,2:size(grad,2)-1);
  B = (ones(imgSize(1),1)*(1:imgSize(2))).*grad(2:size(grad,1)-1,2:size(grad,2)-1);

  CoM = [sum(A(:)); sum(B(:))]/sum(sum(grad(2:size(grad,1)-1,2:size(grad,2)-1)));



end



function [G] = makeKernel(fwhm);

y  = [-fwhm:fwhm]'*ones(1,2*fwhm+1);
x  = y';
r2 = x.^2+y.^2;
s2 = fwhm.^2/log(256);
G  = exp(-r2/2/s2)/2/pi/s2;
end


end