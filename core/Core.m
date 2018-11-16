function   [c]=Core(FixMap,varargin)
%[c]=Core(FixMap,varargin)
%[c]=Core(FixMap,FeatureMap1,BinEdges1,FeatureMap2,BinEdges2,....)
%
%This function counts the occurences of fixations (either as events or as
%weights) for different feature values or bins. VARARGIN is used to provide
%a flexible number of feature dimensions. The output C is literally equal
%to p(fixation|feature) that is in its entries the probability of fixation
%as a function of bin number are given.
%
%
%First, the FEATUREMAP is binned according to the bin edges provided in
%BINEDGES. FEATUREMAP is a column array a featuremap for a given image is
%stored. This is usually generated with Images2FeatMap. Similarly the
%BINEDGES, which is a column vector also, contains the bin edges for
%different featuremap. These BINEDGES are used to bin the featuremap. In
%the usual case, the function FindBinEdges is used to detect the relevant
%bin edges.
%
%In the second step, the fixation occurences are counted within each bin.
%Fixation occurences are provided inside FIXMAP. This is usually created by
%using FixMat2FixMap function.
%
%In the simplest case, the function receives a single featuremap and a
%single vector of binedges. As a consequence, the output C is one dimensional as
%only one featuremap is provided. In other cases, where many featuremap are
%provided, the dimension of the C increases accordingly.
%
%Important Note: if the maximum and minimum values of the BINEDGEs to not
%cover the whole range of the feature entries then you will receive an
%array at line 62 when accumarray is called
%
%SEE ALSO: FindBinEdges, Images2FeatMap, FixMat2FixMap
%
%
%Version 1.0; 16.10.2006
%
%Selim Onat AND Frank Schumann, (2006), any comments, questions etc. can be
%mailed to {sonat,fschuman}@uos.de
%
%
%


if ~isempty(varargin)%check whether any VARARGIN are entered.
    SizeVec = [];%This will be used to force accumarray to have given size.
    tDimen  = length(varargin)/2;
    if rem(tDimen*2,2) == 0 %check for even number of varargins
        %Bin all provided FEATUREMAP(s) by using their corresponding BINEDGES
        for nFeat = 1:2:tDimen*2
            tBin = size(varargin{nFeat+1},1);
            i = (nFeat+1)/2;
            %concatanate feature maps which are in different cell arrays into a
            %matrix with the number of columns equal to the number of
            %features.            
            [n,F(:,i)] = histc(varargin{nFeat},varargin{nFeat+1});

            %histc by construction gives us one additional bin.(see help
            %histc). We assign those points which are in the additional bin to
            %the previous bin.
            F(  F(:,i) == tBin  , i) = tBin-1;
            SizeVec = [SizeVec tBin - 1];%This will be used to force accumarray to have given size.
        end
        %create p(fixation|feature)
        if length(SizeVec) == 1;
           SizeVec = [SizeVec 1];
        end        
        c  = accumarray( F , FixMap(:) ,  SizeVec);
        return
    else
        display('you must provide an even number number of varargin argument. Read the help section.');
        c =[];
        return
    end
else
    display('using this function without varargin does not mean anything. Read the help section.');
    c = [];
end

