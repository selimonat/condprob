function [d]=Feat2PDFile(foimat,parameter)
%[d]=Feat2PDFile(foimat,parameterstructure)
%
%Creates a matrix of PD file names. FOIMAT is a cell array containing the
%list of features. It may be the output of CombineFeatures or
%CombineFeatures3D. Alternatively loaded from ~/tmp/SelectedFeatures.mat.
%In this case however the loaded variables needs a small modification to
%make it compliant with the output of CombineFeatures or CombineFeatures3D.
%
%this line solves the problem:
%for x = 1:size(foi,1);ff{x}{1} = foi{x};end
%
%For each entry (a feature or pair of features or a triplet of features) of features this 
%function returns the filename of PDs in a cell array. FINGERPRINT is used
%to filtes PDs across many candidates.
%
%D contains different fields. MAT for the PD file names. ORDER for the
%relationship of feature names and the pd filename. So for example if file
%name is 2Dimen_feat1_feat2 and the feature entry is {feat2, feat1}. then
%the order will be [2 1]. This way we will be able later to know how to
%modify the posterior distribtions.
%
%Such problems occur becoz I do not compute generally the redundant
%posterior distributions.
%
%PARAMETER can be obtained by GetParameter. Pay attention that when
%p.pooled is equal to 1 there is only one row in the field p.CondInd.
%
%
%Example Usage:
%p                = GetParameters('pooled',1,'nBin',20);
%p.CondInd = [1 192];
%d = Feat2PDFile(ff,p,1);
%FF as computed above. P is the parameter file
%
%
% d.MAT{1}{3,1} will return the PD filename for condition 1 and features
% combination 3 and 1 (whatever they are).
%
%
%Selim, 27-Nov-2008 17:17:03
%Selim, 10-Feb-2009 17:08:15 Completely revised the code. It is compatible
%to 3D cases.
%Selim, 24-Feb-2009 13:24:25 Adated to 1D and many conditions
%vectorize the featurevector.


s =size(foimat);
if sum(s == 1) ~= 0%if we have one dimension, only than columnize the feature list.
    foimat = vertcat(foimat(:));
end

queries    = [];
Order      = [];
d          = [];
nf         = [];
pd_file    = [];


FeatureFingerPrint = [];
d.parameterstring_intact   = parameter.folder;
d.parameterstring          = parameter.folder;%this will be adapted to
%system calls with insertion of escape characters

tDimen     = ndims(foimat);
if size(foimat,2) == 1%correct if the effective dimension is 1
    tDimen = 1;    
end
d.tDimen = tDimen;
%
tfeat      = ceil(length({foimat{:}})^(1/tDimen));
tpair      = tfeat^tDimen;
tcond      = size(parameter.CondInd,1);
%
GetFingerPrints;
%
force = 1;

display([mfilename ': Not already computed or FORCE on, recomputing...']);
Main;    


    function Main
        
        for nf = 1:tpair;
            %
			ProgBar(nf,tpair);	
            %We are here fighting to get all the possible orderings of the feature
            %names. In case of more than 1 dimensions, the filename of the PD can
            %be written in more than one way. If a file is not present it thus
            %does not mean that what we are looking is not computed. We simply
            %didnt really look for the correct filename.
            CandidateNames;
            %
            pd_file{1} = [];
            FindANDStore;
            %
			CombineShortNames;
			%
        end
        %put to the shape of the original feature matrix only if there are
        %more than one dimensions
		if tDimen ~= 1
			d.feat_short_mat = reshape(d.feat_short_mat,repmat(tfeat,1,tDimen));
        end
		for ncond = 1:tcond
            if tDimen ~= 1
                d.MAT{ncond}  = reshape(d.MAT{ncond},repmat(tfeat,[1 tDimen]));
			    d.Order{ncond} = reshape(d.Order{ncond} ,repmat(tfeat,[1 tDimen]));
            end
        end
        %
    end
%
%
%
    function CandidateNames
        %all the problem comes from the fact that a given posterior
        %distribution can be stored with many different names depending on
        %how the feature names are put one after each other on the file
        %name. We here create candidate names and later search for them.
        Order = perms(tDimen:-1:1);
        for nOr = 1:size(Order,1)
            query = [mat2str(tDimen) 'Dimen\#'];%this will be fed to FilterF
            for nd = Order(nOr,:)
                query = [query foimat{nf}{nd} '\#'];
            end
            queries{nOr} = query;
        end
    end

    function FindANDStore
        %Here we run over all candidate file names and find the first
        %matching filename. Moreover we have to remember later the order of
        %the feature maps on the filename. Becoz if we want to plot the
        %posterior distribution on the correct direction. We should know
        %which axis corresponds to which feature.
      
        tOrder = length(queries);
        display([mfilename ': trying to find the PD data, testing different permutations'])
        
        for ncond = 1:tcond
            nOr = 0;
            %
            images = parameter.CondInd(ncond,1):parameter.CondInd(ncond,2);
            CondString =  ['Im_' SummarizeVector(images)];
            CondString = ConditionForSystemCall(CondString);
            d.Cond{ncond} = CondString;
            while isempty(pd_file{1})%run over all possible file names and find the first matching 
                %and store the order of the feature maps.
                nOr = nOr +1;
                if nOr <= tOrder                    
                    pd_file = FilterF('PostFit', queries{nOr} , d.parameterstring,CondString);
                    d.Order{ncond}{nf} = Order(nOr,:);
                else
                    pd_file{1} = 'deleteme';%we store something so that we can go out of the while loop
                    d.Order{ncond}{nf} = [];
                end
            end
            if strcmp(pd_file{1},'deleteme')
                display('not Found :-(')
                pd_file{1} = [];
            else
                display('Found!');
            end
            Store;
            pd_file{1} = [];%put it back to empty so that we can enter to the while loop again!
        end
        %
        %
        function Store
            if length(pd_file) > 1;
                display('there is a problem. There must be a single file here');
                display('but there are more!!! Solve the problem.')
                keyboard;
            elseif length(pd_file) == 1
                d.MAT{ncond}{nf} = pd_file{1};
            end
        end
    end

    function GetFingerPrints;
        %
        GetFeatureFingerPrint;
        [d.parameterstring]=ConditionForSystemCall(d.parameterstring);
        %
        function GetFeatureFingerPrint
            if tDimen ~= 1
            %the indices of the diagonal entries. this lines returns
            %indices of the diagonal entries for matrices of N dimension.
               ii=eval(['sub2ind( ' mat2str(repmat(tfeat,1,tDimen) ) '' repmat([',[1:' mat2str(tfeat) ']'],1,tDimen) ')']);
            else
               ii = 1:tfeat;
            end
            
            %create a finger print to save
            id        = [mat2str(tDimen) 'Dimen_'];  %         
			cc =0;
			for x = ii;
            cc = cc+1;
                id = [id foimat{x}{1}([1 2 end-1 end]) ];
			 	dummy = shortfeat(foimat{x});
				d.feat_short{cc} = dummy{:};
				d.feat_long{cc}  = foimat{x}{1};
            end
            id(end+1) = '_';
            FeatureFingerPrint = id;
            %
            %if the name is too long truncate it. Unix doesnt accept if its too
            %long :)                        
            if length(FeatureFingerPrint ) > 100
                FeatureFingerPrint = FeatureFingerPrint(1:100);
            end
            %
            d.FeatureFingerPrint  = FeatureFingerPrint;			                        
        end
        
    end

    function [STRING]=ConditionForSystemCall(STRING)
        %we put backslashes to make the FilterF detect the parameter specfic
        %information. As it relies on a system command special commands must be
        %escaped.
        %
        toescape = regexp(STRING,{'\[' '\]' '\;' });
        toescape = sort([1 toescape{:}]);
        toescape = toescape + [ 0:(length(toescape)-1)];
        for i = 2:length(toescape);
            %we add the escape character
            STRING= [ STRING( 1:(toescape(i)-2)) '\' STRING((toescape(i)-1):end) ];
        end
        STRING = ['"' STRING '"'];
    end
	function CombineShortNames
			%combine the shortened feature names and create a new string.
			%
			[y x z] = ind2sub([repmat(tfeat,1,tDimen) ],nf);
			XYZ = [y x z];
			XYZ = XYZ(1:tDimen);
			d.feat_short_mat{nf} = cell2str({d.feat_short{[XYZ]}},'|');
	end
end
