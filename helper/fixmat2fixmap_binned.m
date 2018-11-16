function [FixMap]=fixmat2fixmap_binned(fixmat,kernel,CropAmount,varargin)
%[FixMap]=FixMat2FixMap_binned(fixmat,kernel,CropAmount,'fieldname','Value')
%
%It is used to create p(fixation | x,y). It makes use of the "fixmat"
%format of fixations. Allows to filter fixations according to any possible
%criteria e.g. you can create a fixation map with the fixations done on a
%defined set of subjects or a by subset of subjects. You can exclude all
%the fixations whic are done after 2000 ms etc. See below for more options.
%
%INPUTS:
%===========================================
%FIXMAT 
%   is the usual so called fixmat structure array (output of fixread).
%   Any field of the fixmat structure array can be used for filtering
%   fixations before the creation of the FIXMAP.
%
%KERNEL 
%   is smoothening kernel, usually created by make_gaussian function.
%   If it is not provided, the function returns simply the event matrix  If no
%   kernel is provided the matrix is not normalized to unit integral. 
%
%CROPAMOUNT 
%   is the number of pixels that are cropped from each side of the
%   fixation map. If empty automatic zero padding removal is realized
%   otherwise the specified amount of zeros are cropped. See CroopperCleaner
%   for more information.
%
%VARARGIN
%   Any field of the FIXMAT can be used to filter the fixations. The varargin
%   input is directly passed to SelectFix function
%
%   fixmat2fixmat(fixmat,[],[],'image',[1 10 100]) ==> would create a
%   probability distribution with fixations done on only images 1, 10 and
%   100. This usage is also valid for "subject", "fix", "condition" fields of
%   fixmat where the value following the field name is allowed to be a
%   vector.
%   
%   fixmat2fixmat(fixmat,[],[],'start',[100]) ==> would create a pdf by
%   including all the fixations done after 100 ms. This usage is valid also
%   for the "stop" field.
%    
%
%
%OUPUT:
%===========================================
%FIXMAP is a probability distribution function i.e. p(fixation|x,y), as a
%consequence it has unit integral.
%
%
%
%SEE ALSO  : fixread, SelectFix, make_gaussian
%DEPENDENCY: CropperCleaner, SelectFix
%
%Version 1.0; 16.10.2006
%Version 2.0; 11.11.2006
%
%Selim Onat AND Frank Schumann, (2006), any comments, questions etc. can be
%mailed to {sonat,fschuman}@uos.de.
%
%TO DO: update the RECT field after fixread is repaired


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. Clean all the fixation which are bigger than the size of the screen
%now we need to delete all these fixations And extract fixations from the
%fixmat array according to the varargin
factor = 160;
[y x]  = SelectFix(fixmat,varargin{:});
y      = ceil(double(y)./factor);
x      = ceil(double(x)./factor);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2. Construct 2D fixation map
% add 1 and accumulate at the event locations
FixMap = accumarray([y(:) x(:)],1,[fixmat.rect(2) fixmat.rect(4)]./factor);
% the semantic of this is: accumarray ( [yFixCoordinate xFixCoordinate] , ValueAdded  , [Ysize Xsize])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3. Convolve with kernel if provided.
if  ~isempty(kernel);
    %we continue with smoothining if the kernel is different then a scalar
    %or if it is not an empty array.
    FixMap = conv2(FixMap,kernel,'same');
    FixMap = CropperCleaner(FixMap,CropAmount);
    FixMap = FixMap./sum(FixMap(:));
end
