function [g]=GetGauss(fwhm);
%It calls make_gaussian function. The only benefit of this function is that
%the window size is automatically extended as a multiple of FWHM in order
%to have the tails of the gaussian reasonably flat towards the ends of the
%kernel.


Factor = 2.6;%the factor which defines the size of a gaussian window. 
%The size of the window is equal to FWHM*p.Factor, however we prefer to
%have WS as odd number.
WS     = round(fwhm*Factor);
if rem(WS,2) == 0
    WS = WS+1;
end
g      = make_gaussian(WS,WS,fwhm,fwhm,WS/2,WS/2);