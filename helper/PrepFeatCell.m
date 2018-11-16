function [f]=PrepFeatCell(f)
%[f]=PrepFeatCell(f)
%
%Prepares a cell array of feature names into a cell array format that
%CondProb accepts as input.
%
%Selim, 21-Nov-2008 09:50:12



for i = 1:length(f);
    f2{i} = {f{i}};
end
f = f2;