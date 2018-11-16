function All_GetDist(FileList,varargin)
%All_GetDist(FileList,varargin)
%All_GetDist({{BE_File1,BE_File2} {BE_File1,BE_File3}},varargin)
%All_GetDist({{BE_File1,BE_File2} {BE_File1,BE_File3}},NumberOfBootStrap)
%
%
%
%For the binedges given in the cell array FILELIST, it computes the
%N dimensional posterior probabilities. FILELIST contains the
%filenames of the Binedges already computed (just filenames and not the
%absolute path). Number of bootstrap can be entered as VARARGIN. If left
%empty then the one which is in the parameters stored in binedge is used.
%
%Explanation on the input argument FILELIST:
%FILELIST is a cell array containing in a special fashion cells of strings. It
%is organized as FILELIST{PosteriorDistribution}{BinEdges}. For each
%posterior distribution it contains a cell of string arrays containing the
%binedge filenames.
%
%
%Suppose we have a variable F which is obtained by calling :
%
%F = ListFiles('$/BinEdges/*.mat');
%
%F would contain in each of its cells an individual filename. F{1},
%F{2} would contain as strings 2 different binedge files names. Now we
%build FILELIST variable out of F variable.
%
%FILELIST{1}    = {F{1}}; FILELIST{2} = {F{14}}
%OR
%FILELIST    = {{F{1}} {F{14}}}
%==> This means that the first posterior probability distribution will be
%computed using the bin edge file which is located in first cell array of
%F. And the second posterior probability distribution will be computed
%using the 14th bin edge file. The resulting posterior probabilities will
%be one dimensional becoz we provided only one bin edge file per posterior
%distribution.
%
%%FILELIST{1} = {F{1} F{2}}; FILELIST{2} = {F{14} F{15}}
%OR
%FILELIST    = {{F{1} F{2}} {F{14} F{15}}}
%==> This means that the first posterior probability distribution will be
%computed using 2 bin edge files which are the first and second ones in F.
%And the second posterior probability distribution will be computed
%using the 14th and 15th bin edge files. As a consequence the resulting
%posterior distributions will be 2 dimensional.
%
%
%For each file in the FILELIST a given bin edges variable is
%loaded to the memory. Within this variable we have all the information
%regarding to from which features and images was these binedges were
%calculated. Accordingly, after loading a given bin edge file, we load to
%the memory the corresponding feature maps. Finally we call GetDist
%function to compute posterior probabilities. In case many different
%binedge files are provided for multidimensional posterior probability
%distributions, the paramater field of the Bin Edge variable is checked to for equality. That is different
%the parameters that were required to compute the individual binedges are checked for equality. It is a condition
%which is necessary for the computation of the posterior distributions.
%
%Important note on the Cropping Amount for the zero padding removal:
%A bin edge file is computed with a given cropping value applied to the feature map. In this function that given
%value is also used to crop the feature map before the computation of the posterior probabilities. In case many feature maps
%are given for the computation of multidimensional probability distributions, the biggest of the cropping amounts amongs feature maps are selected  and applied to all feature maps that are relevant for the computation of posterior probabilities. the reason is simply that for computation of the joint probabilities only the pixels which have values on all of the feature maps can be used. This may result in a problematic issue in the sense that a given featuremap can be cropped by a bigger amount of pixels which may not be the same amount which was used during the bin edge computation.
%
%
%The results are saved in $/PostDist. The finger print of the binedge files (which are checked to be equal among different
%bin edge files are appended to the end of the file. The first section of the file name shows the features that are used to compute the posterior probabilities separated with a '+' sign.
%
%
%Selim, 31-May-2007 16:11:14
%Selim, 07-Sep-2007 10:21:38; Functionality for coping with N dimensions are
%implemented. Before we had All_GetDist1D, All_GetDist2D etc. a given
%function for each different number of entries. Now one function deals with
%any number of dimensions. Help section improved.
%Selim, 11-Sep-2007 21:28:23; Added the bootstrap number overwritability via varargin.`
%
FL     = FileList;
%
p      = GetParameters;
%here we load the default set of parameters to get the project folder.
BE_path  = [p.Base '/BinEdges/'];
%init some variables

%
tFile = length(FL);%total number of posterior probabilities to be computed.

for nf = 1:tFile;
    %
    check  = 1;
    param  = [];
    input  = [];
    tFeat  = [];
    %
    display([repmat('_',1,25) ' ' mfilename ' ' repmat('_',1,25)]);
    display([ 'Generating posterior probability ' mat2str(nf) ' of ' mat2str(tFile) ]);
    %running over the file list cell array. For each entry in the FILELIST
    %cell array, we will run over the individual entries and load to memory
    %binedges and feature maps for individual featuremaps.
    WritePath  = [p.Base 'PostDist/'];
    %PREPARE INPUT
    PrepareInput_BE;%load the bin edges.
    %
    CheckParam;%check the parameter equality.
    CheckExistence;%check if the results are already computed.
    %
    if check
        PrepareInput_FM;
        %
        ComputePD;
    end
    display([repmat('_',1,25+length(mfilename))  repmat('_',1,25)]);
end
%
%
%
    function ComputePD
        %we checked the equality of the parameters so we can use any entry
        %of the PARAM cell array as argument to GetDist. And as this step
        %is passed we can load the parameter dependent variables.
        %
        fixmat = GetFixMat(param{1}.FixmatInd);
        res    = GetDist(fixmat , param{1} , input{:});
        save(WritePath,'res');
    end

    function PrepareInput_BE
        %load the binedges files
        tFeat      = length(FL{nf});%total number of features.
        display([mat2str(tFeat) '-D posterior probabilities being computed.'])
        WritePath  = [WritePath mat2str(tFeat) 'Dimen_'];
        %PREPARE INPUT
        be = [];
        for nfeat = 1:tFeat;

            display(repmat('-',1,10));
            display(['loading: ' FL{nf}{nfeat}]);
            display(repmat('-',1,10));
            %FEAT1 is the feature name
            %load the bin edges: This will return a variable called BE;
            load([BE_path FL{nf}{nfeat}]);%must return a variable BE
            input{2*nfeat}   = be;%store the binedges variable
            %load the feature maps
            param{nfeat}     = be.p;%we keep this for equality test for later
            %Get Feature Names out of the Path
            fname            = be.fmap.Path(find(be.fmap.Path == '/',1,'last')+1:end);
            WritePath        = [WritePath fname '_Im_' SummarizeVector(input{2}.Im(1):input{2}.Im(2)) '+' ];
            %we append all the feature names one after other.
            if ~isempty(varargin)
                %overwrite the bootstrap value of the parameter file.
                param{nfeat}.nBS = varargin{1};
            end
        end

    end
    function CheckParam
        %check the equality of the parameters.
        if tFeat > 1;
            if isequal(param{:})
                display('Parameter file are equal for both of the BE files...');
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%
                WritePath(end) ='_';%we replace the plus sign with underscore and
                %finally add the Parameter finger print of the BE variables to the
                %final WRITEPATH.
                WritePath = [WritePath 'nBS_' mat2str(param{1}.nBS) '_' ];
                WritePath = [WritePath param{1}.folder '.mat'];%this the final filename
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%
            else
                check = 0;
                display('Parameters of the BE files do not much to each other');
            end
        else
            WritePath(end) ='_';
            WritePath = [WritePath 'nBS_' mat2str(param{1}.nBS) '_'];
            WritePath = [WritePath param{1}.folder '.mat'];
        end
    end
    function CheckExistence
        %check if the file is already computed.
        if 0%exist(WritePath,'file')
            check = 0;
            display('The result is already computed for :')
            display(WritePath);
        end
    end

    function PrepareInput_FM
        %detect the crop amount and load the features.
        ca = [];%crop amount, will be detect below.
        GetCropAmount;
        bf = param{1}.bf;
        for nfeat = 1:tFeat;
            input{2*nfeat-1} = GetFeatMap(input{2*nfeat},ca,bf);%store the featuremap
        end
        function GetCropAmount
            display('Detecting crop amount that was applied to features during the computation of bin edges.');
            for nfeat = 2:2:tFeat*2
                ca(nfeat/2) = input{nfeat}.fmap.CropAmount(1);
                display(['Feature ' mat2str(nfeat/2) ' had a c.a. of ' mat2str(ca(nfeat/2))]);
            end
            if tFeat > 1;
                if sum(diff(ca)) ~= 0
                    display('Featuremaps are cropped with different c.a., The posterior probabilities')
                    display('will be computed with a c.a which was different then the c.a. that was ');
                    display('used for the computation of the binedges. The max of them will be used.');
                else
                    display('Both featuremaps have same c.a.');
                end
            end
            ca = max(ca);
        end

        function [fmap] = GetFeatMap(be,ca,bf);

            be.fmap.Path = LocalizePath(be.fmap.Path);
            fmap = Images2FeatMap( be.fmap.Path , be.fmap.ImIndex, ca,bf);

        end
    end
end
