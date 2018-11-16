function [i] = SyntFix_Core(saliency,tfix);
%[i] = SyntFix_Core(s,tfix);
%
%Given a matrix SALIENCY representing a topographic saliency, this function
%simulates fixation locations of TFIX fixations. SALIENCY may be a fixation
%map, a data-driven saliency map or a click map or any other matrix of 2D.
%
%
%Selim, 31-Jan-2008 20:09:22



%fixation init
i   = zeros(tfix,1);
%
s   = cumsum(saliency(:));
s   = [ 0 ; s];
%we need to add one zero entry to the cumulatif sum, otherwise there is no
%possibility that the first pixel is ever selected whatever its saliency
%is. another intuitive reason is that cumsum eats one of the entries
%therefore possible fixatable position decreases by one.
%
%random points.
r        = rand(1,tfix)*max(s);
%for each of the random points now we find the spatial location it
%corresponds to...
for nf = 1:tfix    
    %
    i(nf,1)   = find( s-r(nf)<=0,1,'last');    
    %
    %we will take the last negative or zero entry in DUMMY; The index of
    %this entry will be the location that is fixated...
end