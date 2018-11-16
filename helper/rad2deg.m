function D=rad2deg(R)

%RAD2DEG Converts angles from radians to degrees
%
%  deg = RAD2DEG(rad) converts angles from radians to degrees.
%
%  See also DEG2RAD, RAD2DMS, ANGLEDIM, ANGL2STR

%  Copyright 1996-2000 Systems Planning and Analysis, Inc. and The MathWorks, Inc.
%  Written by:  E. Byrns, E. Brown
%   $Revision: 1.8 $    $Date: 2000/01/18 02:01:36 $

if nargin==0
	error('Incorrect number of arguments')
elseif ~isreal(R)
     warning('Imaginary parts of complex ANGLE argument ignored')
     R = real(R);
end

D = R*180/pi;