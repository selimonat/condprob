function [PDmat]=Foi2PDMat(foimat,parameter,varargin)
%[PDmat]=Foi2PDMat(foi , parameter , varargin)
%
% This function takes a feature matrix (1D, 2D or 3D), and with the values
% in the VARARGIN assembles the PD which are dealing with this features.
% Values in the VARARGIN are used to filter PDs in case there are more than
% one PD for a given feature combinations. FOIMAT is the output of
% CombineFeatures of CombineFeatures3D. It basically reads all the PDs and
% stores interesting variables in an handy way. PD is the output of
% Feat2PDFile.
%
%Example Usage:
%PDmat        = Foi2PDMat(foi,p.folder);
%
%Selim, 10-Feb-2009 12:04:10


if ~isempty(varargin)
    force = 1;
else
    force = 0;
end

%the second finger print will be the folder
%
PDmat        = Feat2PDFile(foimat,parameter);%create an array of fielnames
PDmat.foimat = foimat;
%
WritePath = ['~/pi/' mfilename '/' PDmat.FeatureFingerPrint PDmat.parameterstring '.mat' ]

if ~exist(WritePath) | force
    Computeit;
    save(WritePath,'PDmat');
else
    load(WritePath);
end


    function Computeit
        res   = [];
        id    = [];
        clear H;
        tCond = length(PDmat.Cond);        
        for nCond = 1:tCond
            tPD   = length({PDmat.MAT{nCond}{:}});
            for i = 1:tPD;                
                [y x] = ind2sub(ceil(([tPD tPD]).^(1/PDmat.tDimen)),i);
                ProgBar(i,tPD)
                load(['~/pi/PostFit/' PDmat.MAT{nCond}{i}]);
                
                %Now we have a problem. suppose PD filename is
                %
                %2Dimen#RG_C_Radius_45#YB_C_Radius_45#_Im_[1:192]+...
                %
                %so when we open the PD file the joint matrix's first dimension will be
                %RG and the second dimension YB. HOWEVER this order might not be what
                %we want. what we wanted could have been the other way around. This is
                %stored in the initial feature matrix but is lost here. However we know
                %the mapping and it is saved in the PD.Order. Therefore each time we
                %load the PD we have to permute the dimensions according to PD Order.
                %.
                %put it back to the normal Ndimensional space ==> correct for shuffling
                %==>revectorize and store
                if PDmat.tDimen ~= 1;%we do this only if the number of dimensions is >1
                   PDmat.C.mean(y,x,nCond,:)   = Vectorize(permute(reshape(res.C.MeanPDF,repmat(res.nBin,[1,res.nDimen])),[PDmat.Order{nCond}{i}]));
                   PDmat.C.var(y,x,nCond,:)    = Vectorize(permute(reshape(res.C.varPDF,repmat(res.nBin,[1,res.nDimen])),[PDmat.Order{nCond}{i}]));
                   PDmat.A.mean(y,x,nCond,:)   = Vectorize(permute(reshape(res.A.MeanPDF,repmat(res.nBin,[1,res.nDimen])),[PDmat.Order{nCond}{i}]));
                   PDmat.A.var(y,x,nCond,:)    = Vectorize(permute(reshape(res.A.varPDF,repmat(res.nBin,[1,res.nDimen])),[PDmat.Order{nCond}{i}]));
                end
                %
                %statistics
                PDmat.C.H(y,x,nCond)       = res.entropy.C.MeanPDF;
                PDmat.A.H(y,x,nCond)       = res.entropy.A.MeanPDF;
                PDmat.DKL.C2A(y,x,nCond)   = res.entropy.KL.C2A;
                PDmat.DKL.A2C(y,x,nCond)   = res.entropy.KL.A2C;
                %
                PDmat.valid(y,x,nCond)     = sum( log10(res.C.MeanPDF) ~= -20);
                PDmat.SSD(y,x,nCond)       = sum((res.C.MeanPDF-res.A.MeanPDF).^2)./PDmat.valid(y,x,nCond);
                PDmat.SSD2(y,x,nCond)      = sum(abs(res.C.MeanPDF-res.A.MeanPDF))./PDmat.valid(y,x,nCond);
                PDmat.SSD3(y,x,nCond)      = sum(sqrt(abs(res.C.MeanPDF-res.A.MeanPDF)))./PDmat.valid(y,x,nCond);
                %
                %Extra info
                PDmat.feat{y,x,nCond}  = {res.feature{PDmat.Order{nCond}{i}}};%feature names for each of the dimensions (After correction);
                PDmat.file{y,x,nCond}  = PDmat.MAT{nCond}{i};%the filename of the PD
                if i == 1
                    PDmat.nBin(nCond)      = res.nBin;
                    PDmat.nDimen(nCond)    = res.nDimen;
                    PDmat.p(nCond)         = res.p;
                end
            end
        end
    end
end