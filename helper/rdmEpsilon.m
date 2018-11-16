function [FeatureMap]=rdmEpsilon(factor,FeatureMap);
%[FeatureMap]=rdmEpsilon(factor,FeatureMap);
%
% Adds a random epsilon noise to all elements of the FEATUREMAP. the
% amount of the noise will be dependent on the value closest to zero value
% within the feature maps. The maximum noise added will be one FACTORTH of
% this smallest element. Each column is treated as an image however this is
% not critical.
%
%Selim 18-Nov-2008 16:39:57

s              = size(FeatureMap);
FeatureMap     = FeatureMap(:);
%find global detect the value closest to zero value.
M              = min(abs(FeatureMap));
%here we would have a problem if M would be equal to zero we have to
%correct this situation if it is the case
if M == 0  
    M = min(abs(FeatureMap(FeatureMap ~= 0)));        
end

FeatureMap     = FeatureMap + rand(s(1)*s(2),1)*(M./factor);
FeatureMap     = reshape(FeatureMap,s);