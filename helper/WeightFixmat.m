D  = double(fixmat.end(fixmat.condition == 2) - fixmat.start(fixmat.condition == 2));
%
be = FindBinEdges(D(:),ones(length(D),1), 10)

names = fieldnames(fixmat);
names = {names{1:end-1}};
for n = 1:length(names)
    W.(names{n}) = [];
end
W.rect = fixmat.rect;
%
for n = 1:length(D)
    i = find(be./D(n) >= 1,1)-1;%find the percentile belongance of the fixation
    W = [W repmat(D(n),1,i)];%replicate that many times
    %
    for n = 1:length(names)
        W.(names{n}) = [W.(names{n}) repmat(fixmat.(names{n}),1,i)];
    end   
end
%
%
%