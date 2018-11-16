function [fixmat]=fixmatResample(fixmat)
%this function is used for bootstraping purposes. It takes a fixmat as
%input and generates a new fixmat as output. the new fixmat contains
%fixations which are selected from the input fixmat with replacement.

%sample with replacements as many fixations as there are in the original
%fixmat.
tFix      = length(fixmat.x);
selection = randsample(tFix,tFix,1);
%
f         = fieldnames(fixmat);
tf        = length(f);
for nf = 1:tf
    %this if statement is here to bypass the rect field.
    if size(fixmat.(f{nf}),2) == tFix
        fixmat.(f{nf}) = fixmat.(f{nf})(selection);
    end
end