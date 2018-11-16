function [p,a,d]=CircularPatch(r);
%[p,a,d]=CircularPatch(r);
%Returns a circular patch of diameter R with unit integral. A is a matrix
%where values represents the angle of each pixels in degrees with respect
%to a horizontal line passing through the middle point.
%
%Selim, 01-Jun-2007 19:53:00

if rem(r,2) ~= 0
    [y x] = meshgrid((1:r)-ceil(r/2),(1:r)-ceil(r/2));
    p     = sqrt(x.^2 + y.^2);
    %
    d     = p;
    %
    p     = p <= r/2;
    p     = p./sum(p(:));
    %
    a     = rad2deg(atan(y./x))+90;
    a     = flipud(fliplr(a));
else
    display('r must have be odd size');
    p = [];
    a = [];
    d = [];
end


