function [p]=GetParameters(varargin);
%[p]=GetParameters(varargin);
%[p]=GetParameters(fieldname,fieldvalue);
%
%This function returns the basic parameters. Without any input it returns
%the default values. If you would like to overwrite any of the fields you
%must first enter the correct FIELDNAME (case sensitive) and then enter the
%value of that field in FIELDVALUE.
%
%It computes automatically the gaussian kernel.
%
%Selim, 31-May-2007 15:20:05
%Selim, 06-Sep-2007 23:31:51 --> added more fields and increased functionality.
%Now the information regarding the conditions is also stored in one of the fields of P. The field CONDIND contains
%for each condition the highest and lowest indices of the images belonging to that condition. That is if the field CONDIND is
% equal to [1 64; 65 128; 129 192; 193 255]; then this means that the first condition is formed by images with indices between
% 1 and 64. The second conditions between images 65 and 128 etc..
%
% IT is currently not possible to overwrite values of CondInd by using an input argument. There are strange dependencies with Param2Folder.

%DEFAULT VALUES: THESE CAN BE OVERWRITTEN BY VARARGIN;
p.FWHM          = 45;%Width parameter of the gaussian kernel
p.CropAmount    = 89;%the biggest cropping amount encountered in the data.
p.kernel        = GetGauss(p.FWHM);
p.nBin          = 20;%total number of bins required
p.start         = 0;%lower limit of the temporal interval
p.end           = 6000;%upper limit of the temporal interval
                    %the presentation time is 6000 however there are many
                    %fixation extendint till 6200 so to not loose them I
                    %set p.end to 6500. This issue must be dealt.
p.fixs         = 2;%first fixation
p.fixe         = 1000;%use a big value to include all the fixations.
p.subjects     = [1:98];%valid subjects
p.FixmatInd    = 2;%This selects which fixmat must be used during the 
%anaysis. This will be the input to GetFixmat.
p.CondInd  = [1 64; 65 128; 129 192; 193 255];%condition delimiters for Anke's data. 
%
p.pooled       = 0;
p.bf           = 2;%binning factor
p.factor       = 1000; %the amplitude of the noise to be added. 1/p.factor
p.weight       = 'Wdefault';%each fixation is weighted 1
%
%

%Overwrite the default values

for nv = 1:2:length(varargin)
    p.(varargin{nv}) = varargin{nv+1};
    p.kernel         = GetGauss(p.FWHM);
end


%
p.ffcommand	= {'fix' p.fixs:p.fixe 'start'  p.start 'end' p.end  'subject'  p.subjects };%this field 
%will be used in Get_Dist.

%THESE MUST BE SET UP ONCE FOR ALL AND MUST BE CUSTOMIZED ACCORDING 2 YOUR
%SETUP: 
p.Base     = '~/pi/';

p.nBS       = 0;%number of bootstraping

%if pooled is 1 than remove the condition indices for categories. Ideally
%one should have taken the first and last entries of p.COndInd but we do
%not want to include pink noise condition in the pooled analysis
if p.pooled == 1
    p.CondInd = [1 192];
end
p.folder 	= Param2Folder(p);
%P.FOLDER is the finger print for the Binedge data which will be computed
%with this set of parameters i.e. it contains a string of parameters and
%their values which are directly related to the binedge computation.
