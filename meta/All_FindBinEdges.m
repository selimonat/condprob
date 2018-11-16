function All_FindBinEdges(f,p)
%All_FindBinEdges(f,p)
%
%
%This function computes the binedges for all the features which are
%in the cell array F. F contains feature map folder names as a cell of
%string arrays. P is loaded by calling GetParameters (see GetParameters
%body).
%
%
%The results are saved with a filename specific to the input
%arguments in the folder $/BinEdges. It contains the feature folder string
%and the indices of the images for which the binedges are computed. In
%addition to this a finger print of the parameter variable P is appended to
%the end of the saved file. Example file name for computed bin edges:
%
%Feat_YBC2D_IM_[1 64]_FWHM_30_CropAmount_0_nBin_20_start_0_end_6500_nBS_0_fix_
%2_subjects_[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24
%25].mat
%
%
%Example Usage:
% Feat = ListFiles('$/FeatureMaps/LUM*');
% p    = GetParameters;
% All_FindBinEdges(Feat,p);
% OR
% All_FindBinEdges({'Feature1' 'Feature2'},p)
%
%
%See also: GetParameters
%
%Selim 31-May-2007 15:22:26;
%Selim 06-Sep-2007 23:54:16; The function now uses the extended functionality of the parameter variable P. That is 
%image indices delimiting the conditions is not anymore hard coded but read from P. As a consequence the WritePath
%does not contain anymore the category reference but simply the indices of the images.

CropAmount = [];
%Load the FixMat fixation data.
fixmat = GetFixMat(p.FixmatInd);
%FIND ALL THE FEATURE MAPS WE HAVE.
%f = GetFeatures;
%Indices for different categories.
im   = p.CondInd;
tCat = size(im,1);%total number of categories.
%
co   = p.CropAmount;%we have to store this becoz it will be the part of the filename
for ncat = 1:tCat;

    for nfeat = 1:length(f)
        display([repmat('_',1,50) mfilename repmat('_',1,50)]);
        %
        display(['Feature: ' mat2str(f{nfeat}) ', Category: ' mat2str(ncat)])
        %                
        WritePath = [ p.Base 'BinEdges/Feat_' f{nfeat} '_Im_' SummarizeVector(im(ncat,1):im(ncat,2)) '_' p.folder '.mat'];
        %
        if ~exist(WritePath,'file')            
            %
            %image indices of category NCAT
            im_in = im(ncat,1):im(ncat,2);
            %Get featuremaps and automatically remove zero padding
            fmap  = Images2FeatMap([p.Base '/FeatureMaps/' f{nfeat}] , im_in ,p.CropAmount,p.bf);
	    %find the amount of zero padding so that we can crop with the same factor the control fixation map. 
	    %this is necessary becoz in case p.CropAmount is [], them according to the zeros padding amount
	    %of the feature maps the crop amount that is necessary to remove from the fixation map will change.
            %
            %control fixation map:
            fixmap    = fixmat2fixmap( fixmat , p.kernel, fmap.CropAmount(1),p.bf, 'image' , im(ncat,1):im(ncat,2) , p.ffcommand{:});
            %
            %find the binedges
            display('Computing bin edges:');

            if p.pooled == 0%in this case the bin edges are found for each image 
                %individually.
            be.data = FindBinEdges(fmap.data,fixmap(:),p.nBin);            
            else%in this case all the images are considered as one single image, i.e.
                %the binedges are found to for all the stimuli in a pooled
                %way.	
            tImage  = size(fmap.data,2);
            be.data = FindBinEdges(fmap.data(:), Vectorize(repmat(fixmap(:),1,tImage)),p.nBin);
            end
            
            if ~isempty(be)
                UpdateBE;
                display('saving');
                display(WritePath);     
                save(WritePath,'be');
            end
            display(repmat('_',1,100));
        else
            display('Bin edges are already computed, skipping...');
        end
    end
end

    function GetCropAmount
%        if co == 0%if CropAmount is 0 in the input argument this means that
%            %we use the same crop amount for the fixation map as for the
%            %feature maps.
%            CropAmount = fmap.CropAmount(1);
%        end

%            CropAmount = fmap.CropAmount(1);
    end

    function UpdateBE
       be.p   = p;
       be.Im  = im(ncat,:);
       fields = fieldnames(fmap);
       for nf = 1:length(fields)
          if ~strcmp(fields{nf},'data');
              be.fmap.(fields{nf}) = fmap.(fields{nf});
          end
       end        
    end
end
