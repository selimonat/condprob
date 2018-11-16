function [res]=CondProb(p,FeatList)
%[varargout]=CondProb(p,FeatList)
%
%
%This is the resulting meta function from the major update of the toolbox.
%Many functions are changed so that they are adapted to CondProb function.
%CondProb function replaces now All_FindBinEdges, All_GetDist, All_PostFit
%etc etc, it embeds all of them. This way all the computations are fastly
%realized becoz we dont need to load the featuremaps each time we call a
%All_FOO function.         
%
%
% P is the parameter file, obtained by calling GetParameters.
% FEATLIST is a cell of features. You may input many features at once
% however they must obey this scheme: F{comparison}{list of features}.
% F{1}{'Lum_C};F{2}{'Mean Lum'} would make the 2 runs with the provided
% features namely Lum_C and Mean_Lum. This can be easily expanded into N
% dimension simply by expanding the list: F{1}{'Lum_C' 'Mean_L'} would make
% 1 analyzes based on the joint distributions of these 2 features.     
%   
% If the results are already computed they are not recomputed unless the
% output is provided which has a priority over the existence of result. 
%
%
%Selim, 22-Aug-2008 17:23:24


res.p  = p;
fixmat = GetFixMat(p.FixmatInd);%load the fixmat indexed in the param file
tEntry = length(FeatList);%number of features
WP     = [];%Write Path
input  = [];%
check  = [];%
ori_p  = p;%store the param file to refresh from overwrites by GetCropAmount
%Force all computations if there is an output argument. Otherwise results are computed only if they are not already computed (Existenz check)
if nargout > 0;force  = 1;display('will force recomputation');else force = 0;end;%force overwrite
%
%
tCat = size(p.CondInd,1);%number of conditions
counter = 0;
for nEntry = 1:tEntry%run over FeatList
    %
    display([repmat('-',1,40) mfilename repmat('-',1,40)]);

    feature = FeatList{nEntry};%the current feature(s). Feature must be a cell array.
    tFeat   = length(feature);%the dimension of the final posterior distributions.
    %
    for cat = 1:tCat;
        %Counting and Displaying Progress
        counter = counter + 1;
        ProgBar(counter,tEntry*tCat);
        display([repmat('-',1,20) mfilename repmat('-',1,20)]);
        display('Computing Features: ')
	    cell2str(feature,'|||')
        display(['Category ' mat2str(cat) ' of ' mat2str(tCat)]);
        %
		%mod operator is added for sarah's fixmat. Otherwise we need to
		%replicated all the feature maps to cover the whole range of
		%images (which are actually only the mirrored versions). We
		%basically need IMAGES only for feature loading.
        %this r for saving anf fixations
		images_ori = p.CondInd(cat,1):p.CondInd(cat,2);%Image indices of the current condition
        %these r for loading featuremaps
		images = mod(images_ori-1,255)+1;
		%
        %We first need to know the Cropping Amount. This is not so important
        %for the 1D cases but in higher dimensions it becomes important as the
        %precise number of cropping depends on both of the features. And a
        %given bin edge which is computed during 1D cases may not be the
        %correct one for the same feature with feature maps cropped with
        %another different amount.
        GetCropAmount;
        %
        PD_Check;%check whether PostDists are already computed
        PDFit_Check;%check whether Fits are already computed
        BFM_Check;%check whether BinnedFeatureMaps are already computed
        %load the Feature Maps
        FM_Get;
        %Detect or Compute the BinEdges
        BE_Get;%
        %Get the posterior distributions
        PD_Get;
        %Compute the Binned Feature Maps
        BFM_Get;
        %     %Analyze the Posterior Distributions
        PD_Fit;
        %.
        %.
        %.
        %.
        %.
        %.
    end
end
        
	
	function GetCropAmount
	display([repmat('-',1,20) 'GetCropAmount' repmat('-',1,20)]);
        %Refresh the param structure P to its initial values. It will be
        %overwritten in each cycle by GetCropAmount; 
	p = ori_p;
	%in case CA is to be automatically detected, find it now.
	if isempty(p.CropAmount);
            display(['CA will be automatically detected.']);
            for nf = 1:tFeat
                %we just open one image (assuming all images have the CA)
                %so that we determine the appropriate ca for the full load
                %of feature maps. 
				fmap   = Images2FeatMap( [p.Base 'FeatureMaps/' feature{nf}] , 1 , [] , p.bf );

				%store the ca;
                ca(nf) = fmap.CropAmount(1);%assumes equal ca for both dims.
            end
            p.CropAmount = max(ca);%the maximum of CAs is the selected for further processing.
	    display(['Detected Crop Amount: ' mat2str(p.CropAmount)]);
	    %
	    %Once we have it detected, we need to update the p.folder becoz
	    %that string contains the parameter specifici finger print.   
	    p.folder = Param2Folder(p);
	    %However, once the p.folder is overwritten we have to be able to
	    %refresh it to the version used as input to the CondProb function.
	    %Otherwise all the remaining analysis will be done with this
	    %CropAmount.
	    %
	else
		display('CA defined in Parameter file will be used')
        end

	end

    function BFM_Check
        %checks the existence of the Binned Feature Maps.
	display([repmat('-',1,20) 'BFM_Check' repmat('-',1,20)]);
        for nFeat = 1:tFeat
            WP.BFM{nFeat}    = [ p.Base 'BinnedFeatureMaps/Feat_' feature{nFeat} '_Im_' SummarizeVector(images_ori) '_' p.folder '.mat'];
            check.bfm(nFeat) = logical(exist(WP.BFM{nFeat},'file'));
        end
        check.bfm = sum(single(check.bfm)) == tFeat;
        display(['BFM existenz: ' mat2str(check.bfm)]);
    end


    function PD_Check
	%Checks whether the Posterior Distributions are already computed.
        display([repmat('-',1,20) 'PD_Check' repmat('-',1,20)]);
        GetWritePath;
        check.pd = logical(exist(WP.PD,'file'));
        display(['PD existenz: ' mat2str(check.pd)]);
        function GetWritePath
            WP.PD  = [p.Base 'PostDist/'];
            WP.PD  = [WP.PD mat2str(tFeat) 'Dimen#'];
            for nFeat = 1:tFeat
                WP.PD = [WP.PD feature{nFeat} '#' ];
            end
            % # are feature separators
            % + separates image related information
            WP.PD = [WP.PD '_Im_' SummarizeVector(images_ori) '+' ];
            WP.PD = [WP.PD 'nBS_' mat2str(p.nBS) '_' ];
            %the reason we add the bs related information here is that it
            %is related to PDs and not BEs
            WP.PD = [WP.PD p.folder '.mat'];%
        end
    end

function PDFit_Check
	%Checks whether the Posterior Distributions are already computed.
        display([repmat('-',1,20) 'PDFit_Check' repmat('-',1,20)]);
        GetWritePath;
        check.pdfit = logical(exist(WP.PDFit,'file'));
               
        display(['PDFit existenz: ' mat2str(check.pdfit)]);
        function GetWritePath
            WP.PDFit  = [p.Base 'PostFit/'];
            WP.PDFit  = [WP.PDFit mat2str(tFeat) 'Dimen#'];
            for nFeat = 1:tFeat
                WP.PDFit = [WP.PDFit feature{nFeat} '#' ];
            end
            % # are feature separators
            % + separates image related information
            WP.PDFit = [WP.PDFit '_Im_' SummarizeVector(images_ori) '+' ];
            WP.PDFit = [WP.PDFit 'nBS_' mat2str(p.nBS) '_' ];
            %the reason we add the bs related information here is that it
            %is related to PDs and not BEs
            WP.PDFit = [WP.PDFit p.folder '.mat'];%
        end
    end



    function FM_Get;
    	%Loads the Feature Maps and add a random epsilon noise to all the
    	%zero values.
        display([repmat('-',1,20) 'FM_Get']);
        if ~check.pd | ~check.bfm | force            
            %load the features.
            if length(feature) == 1
                load_it
            else%if there are more than one features load them after checking
                %whether they are identical. If they are identical we copy
                %the first to create the rest. This way the noise added
                %will also be the same and thus "identical" features will
                %be strictly "identical" and not corrupted by the
                %randomness of the noise.
                if ~isequal(feature{:})
				try
					try
				    	load_it;
					catch
						display('trying again')
						load_it;
						end
				catch
				end
                else
                    display('Next features to be loaded are same, we thus replicate loaded one');
                    tFeat_old = tFeat;
                    tFeat = 1;
                    load_it;%we load only once
                     for nFeat = 2:tFeat_old;
                         res.feature{nFeat} = feature{1};
                         input{2*nFeat-1}   = input{1};
                     end
                     tFeat = tFeat_old;%put back tFeat to its previous value as it is used later.
                end
            end
        else
            display(['Not loading feature maps.'])
        end
        
        function load_it
            for nFeat = 1:tFeat;
                res.feature{nFeat} = feature{nFeat};				
				input{2*nFeat-1}   = Images2FeatMap( [ p.Base 'FeatureMaps/' feature{nFeat}], images , p.CropAmount , p.bf);
                input{2*nFeat-1}.data = rdmEpsilon(p.factor , input{2*nFeat-1}.data );
            end
        end
    end

    function BE_Get
    	%Loads or computes the Bin Edges. BE is needed by PD and BFM. so in
    	%cases where PD and BFM are wanted         
        display([repmat('-',1,20) 'BE_Get' repmat('-',1,20)]);
        if ~check.pd | ~check.bfm | force
			fixmap_co = fixmat2fixmap( fixmat , p.kernel, p.CropAmount  , p.bf, p.weight, 'image' , images_ori , p.ffcommand{:});            
            for nFeat = 1:tFeat;
                %
                display(['Computing BEs ' mat2str(nFeat) ' of ' mat2str(tFeat)]);
                WP.BE{nFeat} = [ p.Base 'BinEdges/Feat_' feature{nFeat} '_Im_' SummarizeVector(images_ori) '_' p.folder '.mat'];
                check.be     = logical(exist( WP.BE{nFeat} , 'file' ));
                %
                if ~check.be | force 
                        %find the binedges
                        if p.pooled == 0
                            %in this case the bin edges are found for each image
                            %individually.
                            be.data = FindBinEdges(input{nFeat*2-1}.data,fixmap_co(:),p.nBin);
                        else
                            %in this case all the images are considered as one single image, i.e.
                            %the binedges are found to for all the stimuli in a pooled
                            %way.
                            tImage  = size( input{nFeat*2-1}.data,2);
                            be.data = FindBinEdges( input{nFeat*2-1}.data(:), Vectorize(repmat(fixmap_co(:),1,tImage)),p.nBin);
                        end
                        %Save each computed binedge results to the BinEdges Folder
                        be.p    = p;
                        be.Im   = images_ori;
                        be.fmap = feature{nFeat};
                        save(WP.BE{nFeat},'be');
                        input{2*nFeat} = be;%function wide
                else
                    BE_Load
                end

            end
        else
            display(['PD and BFM are already computed, not computing BEs.'])
        end
        function BE_Load
            dummy = [];
            display(['BE is already computed...loading from disk.'])
            dummy = load(WP.BE{nFeat});
            input{2*nFeat} = dummy.be;%function wide
        end
    end



    function PD_Get
    	%Computes the Posterior Distributions and analyzes it with All_PostFit.
	%
        %we checked the equality of the parameters so we can use any entry
        %of the PARAM cell array as argument to GetDist. And as this step
        %is passed we can load the parameter dependent variables.
        %
        display([repmat('-',1,20) 'PD_Get' repmat('-',1,20)]);
        if ~check.pd | force
            %
            res    = GetDist(fixmat , p , input{:});
            res.im = images_ori;
            res.p  = p;
            res.feature = feature;
            %
            save(WP.PD,'res');
        else
            display('PD is already computed, not computing again');
        end
        %
    end

    function  PD_Fit
        display([repmat('-',1,20) 'PD_Fit' repmat('-',1,20)]);
            %make the fits, results are saved inside the function            
        if ~check.pdfit | force
            if tFeat == 1
                All_PostFit_1D({WP.PDFit});
            elseif tFeat == 2
                All_PostFit_2D({WP.PDFit});
            elseif tFeat == 3
                All_PostFit_3D({WP.PDFit});
            else
                display('provide a new function for D>2 dists');
            end
        else
            display('PDFit is already computed, not computing again');
        end
    end

    function BFM_Get
        display([repmat('-',1,20) 'BFM_Get' repmat('-',1,20)]);
    	%Computes the Binned Feature Maps.
        if ~check.bfm
        display([repmat('-',1,20) 'BFM_Get' repmat('-',1,20)]);
        for nFeat = 1:tFeat
            display(['Computing BFM ' mat2str(nFeat) ' of ' mat2str(tFeat)]);
            [fmap] = FeatureMap2Binned(input{nFeat*2-1},input{nFeat*2});
            save(WP.BFM{nFeat},'fmap');
        end
        else
            display('BFM is already computed');
        end
    end
end




