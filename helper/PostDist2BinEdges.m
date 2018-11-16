function [fo]=PostDist2BinEdges(filename)
%[fo]=PostDist2BinEdges(filename)
%
%this function takes a filename of a POSTDIST function either one, two or N
%dimensional, and returns the filenames of the corresponding Binedges
%files.
%
%The filename is organized as follows:
%
%NDimen#FEATURENAME#FEATURENAME#....#_Im_[X:Y]+nBS_0_FWHM_45...mat
%  (1)      (2)          (3)           (end-1)      (end)
%
%
%The task of this function is to create from this filename as many
%filenames corresponding to the binedges files that were used. To this
%end, the parts (1) and (end-1) are removed and each of the feature specifying
%parts, 2 and 3 are attached to part 5.
%
%
%
%Selim, 13-Nov-2007 11:43:36
%Selim, 27-Aug-2008 11:31:02--> function adapted to the new name format of
%the posterior distributions.

i       = regexp(filename , '[#,+]' );
i       = [1 i length(filename)];
%
%Separate the FILENAME into its different parts and remove the separator
%signs
for n = 1:length(i)-1
dummy    = filename(i(n):i(n+1));%
%remove the separator signs
dummy    = regexp(dummy,'[^#+]','match');
dummy    = [dummy{:}];
part{n}  = dummy;
end
%remove finally the nBS_X label
ii = find(part{end}=='_',2);
part{end} = part{end}(ii(end):end);%cleaned...
%
%taking from the second element until the last-2 element we will recompose
%the filenames. The last two elements contains always feature unrelated
%information.
for n = 2:length(part)-2
    fo{n-1}    = ['Feat_' part{n} part{end-1} part{end}];
end
%