function [feat2,mat]=CombineFeatures(feat)

%[feat2,mat]=CombineFeatures(feat)
%
%Given a one dimensional cell array of feature list, this functions returns
%a 2D cell array of each possible combination of features. This is
%especially usefull for computing the 2D joint distributions. The
%redundant symmetric part is removed in the FEAT2 output. FEAT2 contains a
%cell array of the feature pairs irrespective of the order of the feature.
%MAT is a cell array matrix which contains all possible pairings. As it is
%symmetric it is redundant. 
%
%USE FEAT2 as input to Condprob, this was the computation will take much
%less time (half basically).
%
%See also CombineFeatures3D
%
%Selim, 22-Aug-2008 18:59:39



tfeat= length(feat);
counter = 0;

for y = 1:tfeat;
    for x= 1:tfeat;
        mat{y,x}={feat{y} feat{x}};
        if y >= x
        counter = counter+1; 
        feat2{counter,1}={feat{y} feat{x}};
        end
    end;
end