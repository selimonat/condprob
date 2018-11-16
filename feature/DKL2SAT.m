function [sat] = DKL2SAT(dkl)
%[sat] = DKL2SAT(dkl)
%
%computes the saturation from dkl transformed image.
%
%Selim, 01-Jun-2007 20:16:27

sat = sqrt(dkl(:,:,1).^2 + dkl(:,:,2).^2);
