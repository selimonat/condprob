function [DKL]=Load_DKLImage(n)
%[DKL]=Load_DKLImage(n)
%Loads Nth image. Loaded images are used in Anke Walter's experiment. N
%must be a scalar. It loads the DKL transformed images.
%
%Different categories differs in their index range
%1-64   :Natural
%65-128 :Fractal
%129-196:Urban
%197:255:Pinky
%
%
%Selim, 01-Jun-2007 16:06:36




i = zeros(960,1280,3);
p = GetParameters;
%
%
file = sprintf([p.Base '/Stimuli/DKL/image_%d.mat'],n);   
load(file);%returns a DKL image.
