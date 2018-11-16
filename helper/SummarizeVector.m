function [x]=SummarizeVector(x)
%[x]=SummarizeVector(x)
% if X is a vector of monotonically increasing numbers then the output X is
% a string summarizing the content of this vector.
%
%Example i/o relations:
%[ 1 2 3 4 5] ==> '1:5'
%
%[1 2 3 10 12 13] ==> '1:3;10:13'
%
%
%Selim, 11-Sep-2007 18:15:27


y = diff(x);
i = find(y ~= 1);
i = [ 1 i i+1  length(x)];
i = sort(i);
i = reshape(i(:),2,length(i)/2);

if isvector(x(i))
    x = mat2str(x(i));
else
    x = mat2str(x(i)');
end

x(x == ' ') = ':';
