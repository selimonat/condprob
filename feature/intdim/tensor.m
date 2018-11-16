function [t,c] = tensor(I,lp_param,pre_param)

% [T,C] = TENSOR(I,LP_PARAM,PRE_PARAM)
% compute maps of edgeness (T) and coherence (C) from luminance image.
% I: (luminance) image
% optional:
% LP_PARAM: vector, giving the parameters for the Gaussian window, 
%   (1) size, (2) std deviation.
% PRE_PARAM: vector, giving the parameters for the noise-reducing low-pass
%   filtering, as above.

% parameters
if (nargin<2)
    lp_param(1) = 60;
    lp_param(2) = 10;
end

% prefilter (optional)
if (nargin>=3 & pre_param(1)>0)
    h = fspecial('gaussian',pre_param(1),pre_param(2));
    I = imfilter(I,h,'conv','same');
elseif (nargin>=4 & pre_param(1)<0)
	I = medfilt2(I,[pre_param(2) pre_param(2)]);
end

% Differentiate w.r.t to x (D1) and y (D2).
D1 = 0.5 * [-1 0 1];
D2 = D1';
Dx = conv2(I,D1,'same');
Dy = conv2(I,D2,'same');

% Square the differentiation results and smooth them.
B = fspecial('gaussian',lp_param(1),lp_param(2));
Ax2 = imfilter(Dy.^2,B,'conv','same');
Ay2 = imfilter(Dx.^2,B,'conv','same');
Axy = imfilter(Dy.*Dx,B,'conv','same');

% calculate 0D vs 1/2D measure
t = Ax2 + Ay2;

% normalise t to lie between 0 and 1
warning off
h = fspecial('gaussian',80,20);
m = imfilter(t,h,'conv','same'); 
t = tanh((atanh(0.8)*10./(eps+9*m+mean(t(:)))).*t);
t = t.^3;
warning on

% calculate coherence (measures anisotropy)
warning off MATLAB:divideByZero
c = sqrt((Ay2 - Ax2).^2 + 4*(Axy).^2) ./ (eps + Ax2 + Ay2);
warning on MATLAB:divideByZero
c(isnan(c)) = 0;
