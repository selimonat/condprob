function [res] = GetDist(fixmat,p,varargin)
%[res] = GetDist(fixmat,p,varargin)
%[res] = GetDist(fixmat,p,FeatureMap1,BinEdges1,FeatureMap2,BinEdges2,...,...)
%
%FIXMAT: output of fixread contains eye data in fixmat format.
%
%P: Parameter File, contains different parameters, such as convolution kernel,
%start time, stop time, number of bins etc.
%It can be called by using Parameters command.
%
%VARARGIN: It must contain an even number of entries. The odd numbered
%entries must contain the Featuremaps (output of Images2FeatMap) and the even numbered
%entries must contain the BinEdges (output of FindBinEdges).
%
%BINEDGES: to have BINEDGES specific for each image BINEDGES must have the
%same number of columns as the number of images in FEATUREMAP. to apply the same
%binedges to all images provide just one row vector.
%
%RES : returns the conditional probabilities p(fixation|feature) for Actual
%and Control distributions for each image and their average over images, the SEM
%computed over each image. Also the BootStrap computed confidence
%intervals for the Control Case (for this you must set out the NBS entry in P,
%to the required number of repetitions) if wanted.
%PrepareOutPut
%%Version 1.0; 16.10.2006
%
%%Selim Onat AND Frank Schumann, (2006), any comments, questions etc. can be
%mailed to {sonat,fschuman}@uos.de.



%Init
ValidInput = [];
v          = [];
res        = [];
pool       = [];
%
ValidateInput;
%
if ValidInput;
    %
    GetVariables;
    %
    Analyze
    %
    PrepareOutPut;
else
    %give the errormessage
    display('there is a mismatch between different featuremaps');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function ValidateInput
        %1/Check the Input and then either continue or stop.
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %First we check if the varargin are entered correctly, that is to say, the
        %number of varargins entered must be always an even number (see help to
        %know why this is necessary). Second we check the compatibility of feature
        %maps, that means we check whether 1/featuremaps are actually computed on
        %the same images 2/their current size are the same
        %
        %If this input variable control step is positive then we continue with the
        %real computations.
        %
        ValidInput = 1;%If VALIDINPUT remains equal to one over these lines we continue with analysis
        %otherwise the function returns an error as its input arguments are not valid.
        v.nDimen = length(varargin)/2;%this is the number of features provided.
        %%%%%%%%%Check whether varargins are correctly entered.
        if rem(v.nDimen*2,2) ~= 0; ValidInput = 0;end%if the varargin is not an even number->STOP
        %%%%%%%%%Check whether Feature are compatible
        %here we run over featuremap structure arrays given in the input and
        %extract the parameters that we want to test their equality later.
        %e.g. we want that all the featuremaps are coming from the same images
        %(ImIndex), we want that CurrentSize of all the featuremaps is equal etc.
        %etc.
        cc = 0;
        for n = 1:2:v.nDimen*2
            cc = cc +1;
            v.CropAmount(cc)      = varargin{n}.CropAmount(1);%store the CropAmounts
            %of different featuremaps. In case they are different the maximum
            %CropAmount is used to crop the fixmation map.
            check{cc}.CurrentSize = varargin{n}.CurrentSize;
            check{cc}.ImIndex     = varargin{n}.ImIndex;
            %    check{n}.ZeroPadAmount = varargin{2*(n-1)+1}.ZeroPadAmount;
        end
        if v.nDimen > 2 %if we have more then one dimensions then check for different feature maps
            %test equality of parameters
            if ~isequal(check{:}); ValidInput = 0;end
        end
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function GetVariables;
        %so if ValidInput is still equal to one then we continue with the
        %1a/Extracting some useful variables once for all so that we do not
        %extract them in each loop of the for loop. 1b./ we prepare the command to
        %call the CORE function. As the core function has to be able to deal with
        %as many as featuremaps we are providing, then it is different for each
        %case and we are preparing it here. 1c/prepare the binedges, this means, if
        %the number of binedges is not the same as the number images and if only
        %one binedges vector is provided then we replicate it over the image
        %dimension so that the same bin edges are used for each image
        %2/Analysis proprement-dite
        %3/Prepare output
        display(['you provided ' mat2str(v.nDimen) ' feature maps.']);

        ArrangeStuff;
        GetControlMap;
        PrepareBinEdges;        
        GetCoreCommand;        
        

        function ArrangeStuff
            %%%%%%%%%1/ Extract usefull parameters such as:%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            v.ImIndex        = varargin{1}.ImIndex;%these are the images stored in FeatureMap
            v.tImage         = size(varargin{1}.data,2);%total number of images
            v.tBinEdges      = size(varargin{2}.data,1);%total number binedges
            v.tBin           = v.tBinEdges - 1;%total number of bins
            v.CropAmount     = max(v.CropAmount);
            %here we check the fixmat. We are deleting all the fixations which are
            %not done on the images stored in FeatureMap. This is necessary for the
            %monte-carlo analysis as the pool of fixations must be the same.
            v.fixmat     = SelectFix(fixmat,'image',v.ImIndex, 'subject', p.subjects, 'start', p.start,'end',p.end,'fix',p.fixs:p.fixe);
            v.tFix       = length(v.fixmat.x); %total number of fixations in cleaned fixmat
            v.fixmat2    = v.fixmat;%create a dummy fixmat, this will be used in bootstraping
            %average number of fixations per image (this will be used in
            %bootstraping when we will be creating fixation matrices)
            v.nBSFix     = round(size(v.fixmat.x,2)./v.tImage);%average number of fixations per image
            v.Faktor     = size( v.ImIndex , 2 ) / size( varargin{1}.data , 2 );
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %PREPARE COMMAND TO CALL CORE FUNCTION
        function GetCoreCommand
            v.base   = [];
            for ni = 1:v.nDimen
                v.base = [ v.base 'varargin{' mat2str(2*(ni-1)+1) '}.data(:,ni_),varargin{' mat2str(2*(ni-1)+2) '}.data(:,ni_),'];
            end
            v.base(end)=[];
            %base is now a string. We will evaluate this string to call the Core
            %function
        end
        function PrepareBinEdges
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %PREPARE BIN EDGES.
            %This means replicates if only one is entered. if only one bin edge is
            %entered then this is used for all the images. To do this we have to
            %fake the script and replicate that binedges given in the input over
            %the image dimension
            
            for nd = 2:2:v.nDimen*2
                if  size(varargin{nd}.data,2) == 1
                    display('you provided one bin edge, the images will be pooled in one.');
                    %replicate the binedges into many binedges over the image dimension.
                    varargin{nd}.data   = repmat(varargin{nd}.data,1,v.tImage);
% %                     varargin{nd-1}.data  = varargin{nd-1}.data(:);%pool the images into one
% %                     %and finally replicate the control fixation map
% %                     v.Co_FixMap = repmat(v.Co_FixMap(:),v.tImage,1);
% %                     v.tImage = 1;%and reset the total image counter to 1
% %                     pool = 1;
                    %                   
                elseif size(varargin{nd}.data,2) == v.tImage
                    display('you are using different bin edges for different images');
                else
                    display('you must provide either 1 bin edges or as many as the number of images.');
                    display('you will probably receive an error soon, think about it!');
                end
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function GetControlMap;
            %build the control fixation map
            v.Co_FixMap = fixmat2fixmap( v.fixmat , p.kernel , v.CropAmount, p.bf, p.weight ,'image',v.ImIndex, p.ffcommand);
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function Analyze
        %FINALLY WE PROCEED WITH THE ANALYSIS        
	for ni_ = 1:v.tImage;            
            fprintf('.')
            %display([repmat('.',1,tImage-ni_), 'processing image ' mat2str(ni)]);
            CallCore;            
            BootStrap;
    end
    fprintf('\n')
        %count the fixations at the bin edges.

        function CallCore
            %create the actual fixation map            
            GetActualMap;
            %Store the results as a vector irrespective of its dimensions, in
            %the columns of Raw.               
            eval(['res.A.Raw(:,ni_) = Vectorize(Core(v.Ac_FixMap,' v.base '));']);
            eval(['res.C.Raw(:,ni_) = Vectorize(Core(v.Co_FixMap,' v.base '));']);
        end
    
        function GetActualMap
            %this must give us 2 different things depending on pooled or
            %non pooled case. In the non-pooled case, it should return the
            %current fixation map for the current image which is specified
            %by NI variable. In the pooled case NI is irrelevant and fixmap
            %for each of the images must be concatanetad. Basically the
            %loop in ANALYZE function must be run here.
            v.Ac_FixMap = [];

% %             if pool == 1;
% %                 tImage = length(v.ImIndex);
% %                 dummy = zeros(varargin{1}.CurrentSize(1)*varargin{1}.CurrentSize(2),tImage);
% %                 for ni__ = 1:length(v.ImIndex)
% %                     ni = v.ImIndex(ni__);
% %                     dummy(:,ni__) = Vectorize(fixmat2fixmap(v.fixmat, p.kernel, v.CropAmount, p.bf, p.weight ,'image', ni, 'fix' , p.fixs:p.fixe,'start',p.start,'end',p.end,'subject',p.subjects));
% %                 end
% %                 v.Ac_FixMap = dummy(:);
% %                 clear dummy;
% %             else
                ni  = v.ImIndex(ni_);
                v.Ac_FixMap = fixmat2fixmap(v.fixmat, p.kernel, v.CropAmount, p.bf, p.weight ,'image', ni, 'fix' , p.fixs:p.fixe,'start',p.start,'end',p.end,'subject',p.subjects);
% %             end
        end
        
        function BootStrap
            %start with monte-carlo.
            %1/Create a sample of fixations by randomly selecting fixations
            %with replacement
            %2/Count the fixations at the bin edges by using the synthetic sample
            for  nbs = 1:p.nBS;%main loop for bootstraping.
                %For each image, p.NBPS bootstrap cycles are realized.
                %in each of these cycles NBSFIX fixations are choosen randomly
                %from the pool of fixations. The pool of fixation are all the
                %fixations present in the fixmat. After this selection step the
                %same posterior probability computation is done. The results
                %represents the p(fixation|feature) under the null hypothesis
                %where the fixations are not driven by bottom-up image content.
                %Steps
                %1/ First choose random fixations from our data set
                %2/ Create a fixation map with those fixations
                %3/ Compute the posterior probability
                display(['Bootstraping: ' mat2str(nbs/p.nBS*100) '% completed...']);
                %Step1: THIS STEP IS WRONG BECOZ THE NUMBERS IN V RANDINDEX
				%CAN NOT BE BIGGER THAN 1 THEREFORE THE SELECTION WITH
				%REPLACEMENT DOES NOT FUNCTION
                v.RandIndex = ismember(1:v.tFix,randsample(v.tFix,v.nBSFix));
                fixmat2     = SelectFix(v.fixmat,v.RandIndex);
                %Step 2:
                v.BS_FixMap = fixmat2fixmap( v.fixmat2, p.kernel, v.CropAmount, p.bf, p.weight,'fix' , p.fixs:p.fixe,'start',p.start,'end',p.end,'subject',p.subjects);%
                %Step 3:
                eval(['v.BS_Raw(:,nbs,ni) = Vectorize(Core(v.BS_FixMap(:),' v.base '));']);
            end
        end
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function PrepareOutPut
        %PREPARE OUTPUT to have the mean and SEM about the bins.

        for Co = ['A', 'C']%run over A,C and Cond
            res.(Co).PDF       = res.(Co).Raw ./ repmat( sum(res.(Co).Raw),[size(res.(Co).Raw,1) , 1] );
            res.(Co).MeanPDF   = nanmean(res.(Co).PDF,2);%take the average of counts over images
            res.(Co).MedianPDF = nanmedian(res.(Co).PDF,2);%take the median
            res.(Co).varPDF    = nanvar(res.(Co).PDF,0,2);%take the variance over images
            res.(Co).stdPDF    = nanstd(res.(Co).PDF,0,2);%take the std over images
            res.(Co).SEMPDF    = res.(Co).stdPDF/sqrt(v.tImage);%compute the standard error of mean
        end

            %a small control for the flatness of the control distribution
            display(['maximum step size is :' mat2str(mean(max(diff(res.C.MeanPDF)))) ]);
                    
        if p.nBS ~= 0
            %Here we want to have an estimate of the SEM for the control
            %distribution. for this we first compute the variance over
            %boot-straps for all images and average the results over images.
            res.BS.d       = v.BS_Raw;
            res.BS.SEM     = mean(var(v.BS_Raw,0,2)./v.tImage,3);
            res.BS.n       = p.nbs;%store how many boot-straps were done.
        else
            res.BS.SEM     = [];
            res.BS.n       = 0;
        end


        %usefull to reshape the vectors later
        res.nDimen = v.nDimen;%store the number of dimension we had. We must know this.
        res.nBin   = v.tBin;
    end




end
