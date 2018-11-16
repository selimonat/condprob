function [binned]=binner_2D(tobin,delta)
%[binned]=binner(tobin,binsize)
%
%   Bins the data in the matrix TOBIN into non-overlappingbins of BINSIZE pixels to reduce
%   the size. 
%
%   BINSIZE: binning size in pixel.
%   TOBIN  : matrix to resize.
%
%   Takes care that BINSIZE is a divisor of the size(tobin) otherwise
%   nothing is computed.
%
%Selim, 17-Dec-2007 23:01:08

[y x]= size(tobin);
c    = delta^2;
if rem(x,delta) == 0 & rem(y,delta) == 0
    binX   = 0:delta:x;
    binY   = 0:delta:y;

    for x = 1:length(binX)-1
        for y = 1:length(binY)-1
            binned(y,x)= sum(sum( tobin(  binY(y) + 1 : binY(y+1) ,  binX(x) + 1 : binX(x+1) )));
            %take the average now           
        end
    end
    binned= binned./c;
else 
    display( [ 'mfilename: DELTA must be a divisor of the size of TOBIN'])
    binned = [];
end