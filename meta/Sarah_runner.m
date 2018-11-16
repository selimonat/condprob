clear all
%load the features
load ~/pi/tmp/SelectedFeatures_extended.mat
foi = PrepFeatCell(foi);
%foi = fliplr(foi);
%Condition indices
CondInd = [1 64; 65 128; 129 192; 193 255];
CondInd = [CondInd ; CondInd+255];


%DEFAULT CASE
p   	   = GetParameters('subjects',1:45,'FixmatInd',7,'CondInd',CondInd);
CondProb(p,foi)

%LEFT RIGHT SEPARATELY

%p   	   = GetParameters('subjects',1:45,'FixmatInd',8,'CondInd',CondInd);
%CondProb(p,foi)
p   	   = GetParameters('subjects',1:45,'FixmatInd',9,'CondInd',CondInd);
CondProb(p,foi)
