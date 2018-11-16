function [FixMap]=fixmat2fixmap_nono(fixmat,kernel,CropAmount,ResizeFactor,WeightField,varargin)
%[FixMap]=FixMat2FixMap_nono(fixmat,kernel,CropAmount,ResizeFactor,WeightField,'fieldname','Value',...)
%
%Same as FixMat2FixMap but does not normalize to unit integral
%
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
%RESIZE FACTOR
%   The factor by which the image must be resized
%
%WEIGHT FACTOR
%   Fieldname representing the weight of each fixations. By default it is 1
%   for each fixation. However when fixmat contains a WeightField which is
%   different than it can be given as input. It should be a string. If no
%   weight field is needed to be used or fixmat has no Weightfield, use
%   simply anything as input. The default would then be used.
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
%08-Dec-2009 13:03:28, possibility of choosing different weights implemented.
%
%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. Clean all the fixation which are bigger than the size of the screen
%now we need to delete all these fixations And extract fixations from the
%fixmat array according to the varargin. W is the weight vector for each
%fixation.
[y x selection]  = SelectFix(fixmat,varargin{:});
%extract the weights
if isfield(fixmat,WeightField)%if there is no such field than assume a weight of 1
    w = fixmat.(WeightField)(selection);
else
    w = ones(1,sum(selection));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2. Construct 2D fixation map
% add W and accumulate at the event locations. W comes from the fixation
% weights.
FixMap = accumarray([y(:) x(:)],w,[fixmat.rect(2) fixmat.rect(4)]);
% the semantic of this is: accumarray ( [yFixCoordinate xFixCoordinate] , ValueAdded  , [Ysize Xsize])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3. Convolve with kernel if provided.
BF      = ResizeFactor;
kernel2 = ones(BF)./BF.^2;
if  ~isempty(kernel);
    %we continue with smoothining if the kernel is different then a scalar
    %or if it is not an empty array.
    FixMap = conv2(sum(kernel),sum(kernel,2),FixMap,'same');
    
    FixMap = CropperCleaner(FixMap,CropAmount);
    if BF == 2 %in case the BF is 2 convolution is faster so we ise binner_im
        FixMap = binner_im(FixMap,kernel2);
    elseif BF > 2 %in all other cases binning without convolution (for loop) is faster.
        %so we use 
        FixMap = binner_2D(FixMap,BF);
    elseif BF == 1
        FixMap = FixMap;
    end
    %normalize to unit integral
    FixMap = FixMap./sum(FixMap(:));
end
