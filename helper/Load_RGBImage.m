function [i]=Load_RGBImage(n)
%[i]=Load_RGBImage(n)
%Loads Nth image. Loaded images are used in Anke Walter's experiment. N
%must be a scalar.
%
%Different categories differs in their index range
%1-64   :Natural
%65-128 :Fractal
%129-196:Urban
%197:255:Pinky
%
%22-May-2007 16:23:42, Selim.


%
%

file = sprintf(['/net/space/users/sonat/project_Integration/Stimuli/BMPs/image_%d.bmp'],n);   
i    = imread(file);


