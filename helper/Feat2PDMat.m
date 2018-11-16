function [PDmat]=Feat2PDMat(parameter,FeatList)
%[PDmat]=Feat2PDMat( parameter , foi)
%
% This function reads all the PDs and stores interesting variables in an
% handy way.
%
%
% This function takes a feature matrix (1D, 2D or 3D, same as input to
% CondProb) and assembles the PDs which are dealing with this
% features. In the case of 2 and 3D, FOIMAT is
% the output of  CombineFeatures or CombineFeatures3D, respectively. The
% results must be saved by hand preferentially to ~/pi/PDmats.
%
%
%
%
%Selim, 10-Feb-2009 12:04:10
%Selim, 09-Dec-2009 15:46:25 ==> Always force on!!!



%
PDmat          = Feat2PDFile(FeatList,parameter);%create an array of fielnames
PDmat.FeatList = FeatList;
%
tCond = length(PDmat.Cond);        
tFeat = length(FeatList);
%
WritePath = [parameter.Base mfilename '/' PDmat.FeatureFingerPrint PDmat.parameterstring_intact '.mat' ];

Computeit;
Matrixize;


    function Computeit
        res   = [];
        id    = [];
        clear H;
        for nCond = 1:tCond
            tPD   = length({PDmat.MAT{nCond}{:}});
            for i = 1:tPD;                
                ProgBar(i,tPD);
                load([parameter.Base 'PostFit/' PDmat.MAT{nCond}{i}]);
                tIm = length(res.im);
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
                   %
                   PDmat.C.mean(:,nCond,i)   = Vectorize(permute(reshape(res.C.MeanPDF,repmat(res.nBin,[1,res.nDimen])),[PDmat.Order{nCond}{i}]));
                   PDmat.C.var(:,nCond,i)    = Vectorize(permute(reshape(res.C.varPDF,repmat(res.nBin,[1,res.nDimen])),[PDmat.Order{nCond}{i}]));
                   PDmat.A.mean(:,nCond,i)   = Vectorize(permute(reshape(res.A.MeanPDF,repmat(res.nBin,[1,res.nDimen])),[PDmat.Order{nCond}{i}]));
                   PDmat.A.var(:,nCond,i)    = Vectorize(permute(reshape(res.A.varPDF,repmat(res.nBin,[1,res.nDimen])),[PDmat.Order{nCond}{i}]));
                                      
                   %Take also the RAW data 
                   for ima = 1:size(res.A.Raw,2)                        
                       PDmat.A.raw(:,nCond,i,ima ) = Vectorize(permute( reshape(res.A.Raw(:,ima),[repmat(res.nBin,1,res.nDimen)] ) , [PDmat.Order{nCond}{i}]));
                       PDmat.C.raw(:,nCond,i,ima ) = Vectorize(permute( reshape(res.C.Raw(:,ima),[repmat(res.nBin,1,res.nDimen)] ) , [PDmat.Order{nCond}{i}]));                       
                   end
                   
                   
                else                    
                   PDmat.C.mean(:,nCond,i)   = res.C.MeanPDF;
                   PDmat.C.var(:,nCond,i)    = res.C.varPDF;
                   PDmat.A.mean(:,nCond,i)   = res.A.MeanPDF;
                   PDmat.A.var(:,nCond,i)    = res.A.varPDF;
                   %newly added to have the raw data also  
                   %newly added to have the raw data also,
                   %the reason for the "1:tIm" term is that the
                   %PINK noise has only 63 conditions so if we put a ":" it
                   %gives an error as previously the size was raised to 64
                   PDmat.A.raw(:,nCond,i,1:tIm)  = res.A.Raw;
                   PDmat.C.raw(:,nCond,i,1:tIm)  = res.C.Raw;
                end                
                
                %
                %statistics information measures
                PDmat.C.H(nCond,i)       = res.entropy.C.MeanPDF;
                PDmat.A.H(nCond,i)       = res.entropy.A.MeanPDF;
                PDmat.DKL.C2A(nCond,i)   = res.entropy.KL.C2A;
                PDmat.DKL.A2C(nCond,i)   = res.entropy.KL.A2C;
                PDmat.DKL.d(nCond,i)     = (PDmat.DKL.A2C(nCond,i) + PDmat.DKL.C2A(nCond,i))./2;
                %adding the information about individual images
                %turining this part off, becoz 2D fitter function in the
                %Condprob was not updated in order to generate the
                %individual DKL values. One has to re-run the updated
                %fitter and then activate the linews below.
                PDmat.entropy.raw(nCond,i,1:tIm)   = res.entropy.A.Raw;
                PDmat.DKL.raw.C2A(nCond,i,1:tIm)   = res.entropy.KL.rawC2A;
                PDmat.DKL.raw.A2C(nCond,i,1:tIm)   = res.entropy.KL.rawA2C;
                PDmat.DKL.raw.d(nCond,i,1:tIm)     = squeeze((PDmat.DKL.raw.A2C(nCond,i,1:tIm) + PDmat.DKL.raw.C2A(nCond,i,1:tIm))./2);
                %%number of non-zero entries
                PDmat.valid(nCond,i)     = sum( log10(res.C.MeanPDF) ~= -20);
                %
                %Extra info
                PDmat.feat(nCond,i)  =	{{res.feature{PDmat.Order{nCond}{i}}}};%feature names for each of the dimensions (After correction);
                PDmat.file(nCond,i)  = {PDmat.MAT{nCond}{i}};%the filename of the PD
                
            end                                 
        end
     PDmat.nBin      = res.nBin;
     PDmat.nDimen    = res.nDimen;
     PDmat.p         = res.p;
    end
    function Matrixize         
        %expand the last dimension as many as the number of dimensions
        s = size(PDmat.C.mean);%(bin,category,features1,feature2,...)
        PDmat.C.mean = reshape(PDmat.C.mean(:),[s(1),s(2), repmat(tFeat,1,PDmat.tDimen) ]);
        PDmat.C.var  = reshape(PDmat.C.var(:) ,[s(1),s(2), repmat(tFeat,1,PDmat.tDimen) ]);                
        
        PDmat.A.mean = reshape(PDmat.A.mean(:),[s(1),s(2), repmat(tFeat,1,PDmat.tDimen) ]);
        PDmat.A.var  = reshape(PDmat.A.var(:) ,[s(1),s(2), repmat(tFeat,1,PDmat.tDimen) ]);
        
        PDmat.C.raw  = reshape(PDmat.C.raw(:) ,[s(1), s(2), repmat(tFeat,1,PDmat.tDimen)  size(PDmat.C.raw,4) ]);
        PDmat.A.raw  = reshape(PDmat.A.raw(:) ,[s(1), s(2), repmat(tFeat,1,PDmat.tDimen)  size(PDmat.A.raw,4) ]);
        
        s = size(PDmat.C.H);%(category,feature1,feaeture2,...)
        PDmat.C.H         =  reshape(PDmat.C.H    ,[s(1) repmat(tFeat,1,PDmat.tDimen) ]);
        PDmat.A.H         =  reshape(PDmat.A.H    ,[s(1) repmat(tFeat,1,PDmat.tDimen) ]);
        PDmat.DKL.C2A     =  reshape(PDmat.DKL.C2A,[s(1) repmat(tFeat,1,PDmat.tDimen) ]);
        PDmat.DKL.A2C     =  reshape(PDmat.DKL.A2C,[s(1) repmat(tFeat,1,PDmat.tDimen) ]);        
        PDmat.DKL.d       =  reshape(PDmat.DKL.d  ,[s(1) repmat(tFeat,1,PDmat.tDimen) ]);        
        PDmat.valid       =  reshape(PDmat.valid  ,[s(1) repmat(tFeat,1,PDmat.tDimen) ]);        
        PDmat.feat        =  reshape(PDmat.feat   ,[s(1) repmat(tFeat,1,PDmat.tDimen) ]);        
        PDmat.file        =  reshape(PDmat.file   ,[s(1) repmat(tFeat,1,PDmat.tDimen) ]);        
    end
end
