function [fixmat]=SyntFixMat(s,tsub,tfix);
%[fixmat]=SyntFixMat(s,tsub,tfix);
%
%
%This function creates fixation data based on the saliency of features
%represented in Posterior Distributions. Fixation data is organized as a
%fixmat with TSUB subjects and TFIX fixations per subject and image. S is
%the output of Saliency.m. This function therefore transforms S into a
%fixation data. It heavily relies on SyntFix_Core. The resulting fixmats
%are saved in $/SyntFixMats
%
%%Selim, 31-Jan-2008 20:09:22
%%Selim, 29-Aug-2008 13:34:34, commented.


BF = 8;
InitFixmat;
ti = size(s.data,2);

WritePath = ...
['~/project_Integration/SyntFixMats/fixmat_tsub_' mat2str(tsub) '_tfix_' mat2str(tfix) '_' s.Path];

if ~exist(WritePath,'file') | ~isempty(varargout)

%run over images
for ni = 1:ti    
    display([mfilename ': ' mat2str(ni./ti*100) ' % is completed.']);
    index = s.ImIndex(ni);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %HERE WE ARE GOING TO DOWNSAMPLE THE SALIENCY MAPS AND THEN REMOVE THE
    %ZERO PADDING RELATED ARTEFACTS. WE WILL LATER NEED TO UNDO THE EFFECTS
    %OF THESE PROCESSES TO PORT BACK THE FIXATION COORDINATES INTO THE
    %ORIGINAL IMAGE COORDINATES.
    %
    %extract individual saliency maps and crop the edges
    sm_ori = reshape( s.data(:,ni) , s.CurrentSize );
    %bin the saliency map. at this stage the saliency map contains the
    %zeropadding related zeros at the edges. we dont care right now but in
    %the next step we will remove those artefacts.
    sm_bin = binner_2D(sm_ori,BF);
    %becoz we have stored the mask (see Saliency) we can now apply the
    %binning to the mask also and select easily the non-contaminated pixels
    %during the binning procedure...        
    mask   = binner_2D(s.mask,BF) == 0;
    s_final= size(CropperCleaner(mask));
    s_ori  = size(mask);
    sm     = reshape(sm_bin(mask),s_final(1),s_final(2));%this is right now the cleaned 
    %saliency map ready to be used for fixation generation.
    %
    %the difference of s_ori and s_final is the number of pixels removed
    %after binning is applied...they must be equal across both dimensions
    shift  = (s_ori - s_final)/2;%we divide by 2 to get the increment of one side.
    %

    for nsub = 1:tsub
        %get fixations
        [i] = SyntFix_Core( sm , tfix );
        %
        %NOW WE HAVE OUR GENERATED FIXATION DATA...WE HAVE TO 1/ ADD A
        %CONSTANT OF THE SAME AMOUNT THAT WAS REMOVED BECOZ OF ZERO PADDING
        %AND 2/ WE HAVE TO SHIFT ALL THE FIXATIONS SO THAT THEIR FINAL
        %POSITION IS AT THE MIDDLE OF THE BINS NOT AT THE EDGES. OUR AIM IS
        %TO MAKE THESE FIXATION COMPATIBLE WITH RECORDED FIXATIONS.
        %
        %first transform them to normal space...
    	[y x] = ind2sub([size(sm)],i);
        %becoz of the cropped of the edges we need to add that constant
        %value so that the generated fixation coordinates make sense in the
        %image coordinates...%asssumes equal zero padding over 2 dimens.
        %
        %now we multiply the coordinates with the binning factor so that if
        %a fixation is selected at position 1 or 100 in the binned map its
        %position in the pre-binned map is 2 or 200. however becoz
        %upscaling does not fill all the space. The fixations when upscaled
        %they will always be on the position which are multiple of BF. for
        %that reason I randomly distribute each fixation to the interval of
        %[BF*N   BF*(N+1)] for each N. Taking floor after the random number
        %addition ensures that all fixations are equally distributed.
        %Before all this we add the number of bins we removed at the top...
        %
        %
        y = floor((y+shift(1)).*BF+1 - rand(1,length(y)).*BF);
        x = floor((x+shift(2)).*BF+1 - rand(1,length(x)).*BF);
        %                        
        %
        UpdateFixmat;
   end    
end
SaveIt;
else
    display('the file is  already computed for these input parameters');
end
%
    function InitFixmat
        fixmat.x         = zeros([],[],'uint32');
        fixmat.y         = zeros([],[],'uint32');
        fixmat.image     = zeros([],[],'uint16');
        fixmat.rect      = [0 s.CurrentSize(1) 0 s.CurrentSize(2)];
        fixmat.condition = zeros([],[],'uint16');
        fixmat.subject   = zeros([],[],'uint16');
        fixmat.fix       = zeros([],[],'uint16');
    end
%
    function UpdateFixmat

        %
        fixmat.x         = [fixmat.x x];
        fixmat.y         = [fixmat.y y];
        fixmat.condition = [fixmat.condition repmat(ceil(index./64),1,tfix)];%64 is total number of images per condition.
        fixmat.image     = [fixmat.image repmat(index,1,tfix)];
        fixmat.subject   = [fixmat.subject repmat(nsub,1,tfix)];
        fixmat.fix       = [fixmat.fix 1:tfix];
    end
    function SaveIt

        display('saving the data');
        save(WritePath,'fixmat');
    end
end
