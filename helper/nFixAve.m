function [ave]=nFixAve(fixmat);
%[ave]=nFixAve(fixmat);
%
%Computes the average number of fixations for each condition in a fixmat.
%
%Selim, 23-Dec-2007 01:24:08


tcond = length(unique(fixmat.condition));

for nc = 1:tcond   
 ave(nc) = sum( fixmat.condition == nc )./length(unique(fixmat.subject(fixmat.condition==nc)))./length(unique(fixmat.image(fixmat.condition == nc)));
end
