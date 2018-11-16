function [binned]=binner_2D_RGB(tobin,delta)
%[binned]=binner_2D_RGB(tobin,binsize)
%
%   Bins the data in the matrix TOBIN into non-overlappingbins of BINSIZE pixels to reduce
%   the size. The difference of this function from binner_2D is that here
%   we take the mean value for each pixel rather then simply taking the
%   sum. In cases where a RGB image is required to be binned this is a
%   necessary step as RGB images' pixels are bound to be within [ 0 1].
%
%   BINSIZE: binning size in pixel.
%   TOBIN  : matrix to resize.
%
%   Takes care that BINSIZE is a divisor of the size(tobin) otherwise
%   nothing is computed.
%
%Selim, 17-Dec-2007 23:01:08
%Selim, 05-Feb-2008 10:47:09 adapted to 3D matrices such as RGB images.


[y x z]= size(tobin);
%init the variable which will be the binned results.
binned =  repmat(zeros([y x]/delta),[1 1 z]);

if rem(x,delta) == 0 & rem(y,delta) == 0
    binX   = 0:delta:x;
    binY   = 0:delta:y;
    for zi = 1:z
        for xi = 1:length(binX)-1
            for yi = 1:length(binY)-1
                binned(yi,xi,zi)= mean(mean( tobin(  binY(yi) + 1 : binY(yi+1) ,  binX(xi) + 1 : binX(xi+1), zi )));
            end
        end
    end
else 
    display( [ 'mfilename: DELTA must be a divisor of the size of TOBIN'])
    binned = [];
end