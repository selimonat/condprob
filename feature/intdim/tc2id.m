function [i2d, i1d, i0d] = tc2id(t,c)

% [I2D,I1D,I0D] = TC2ID(T,C)
% converts gradient and orientation variance maps to barycentric
% coordinates within the iD triangle.
% T,C: gradient and orientation variances returned from tensor.m
% I2D,I1D,I0D: barycentric coordinate maps

i2d = t-t.*c;
i1d = t.*c;
i0d = 1-t;
