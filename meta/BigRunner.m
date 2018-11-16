
% Non-POOLED 1D case Bin 20;
clear all
p   	   = GetParameters('pooled',0,'nBin',20,'CondInd',[1 192]);
foi = PrepFeatCell(ListFolders('~/pi/FeatureMaps/*_*'))
f   = CondProb(p,foi)
Feat2PDMat(p,foi);
%WITH THIS RUN I GOT ALL THE RANKING OF THE FEATURES. THIS WAS DONE ON A
%BASIS WHERE I DIDNT CARE ABOUT DIFFERENT CATEGORIES (except for the pink
%noise)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Non-POOLED 1D case Bin 20; WEIGHTED VS NONWEIGHTED
clear all
p   = GetParameters('nBin',20);
load ~/pi/tmp/SelectedFeatures.mat
foi = PrepFeatCell(foi);
CondProb(p,foi)
PD = Feat2PDMat(p,foi);
save ~/pi/PDmats/Baseline_1D_allfeatures_20bin PD
% Non-POOLED 1D case Bin 20; WEIGTH BY CLICK MAPS
clear all
p   = GetParameters('nBin',20,'weight','Wclick' );
load ~/pi/tmp/SelectedFeatures.mat
foi = PrepFeatCell(foi);
CondProb(p,foi)
%Feat2PDMat(p,foi);
%WITH THIS RUN I GOT DKL RESULTS AFTER WEIGHING THE FIXATIONS BY CLICK MAPS
%RUN THIS TO SEE DIFFERENT SALIENCY CURVES
for i = 1:15;hold off;plot(squeeze(pd1.A.mean(:,1:3,i)),'linewidth',3);hold on;plot(squeeze(pd2.A.mean(:,1:3,i)),'--','linewidth',3);title(pd1.feat_short_mat{i});drawnow;pause;;;end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Non-POOLED 1D case Bin 64 (for the 1D case); NONWEIGHTED
clear all
p   = GetParameters('nBin',64);
load ~/pi/tmp/SelectedFeatures.mat
foi = PrepFeatCell(foi);
CondProb(p,foi)
PD = Feat2PDMat(p,foi);
save ~/pi/PDmats/Baseline_1D PD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Non-POOLED 1D case: fixation by fixation
clear all
load ~/pi/tmp/SelectedFeatures.mat
foi = {foi{[2 6 11 16]}};
foi = PrepFeatCell(foi);
for nF = 1:48
for nfix = 1:15;
    p   = GetParameters('nBin',64,'fixs',nfix,'fixe',nfix,'FixmatInd',2,'subjects',nF);
    f   = CondProb(p,foi);
    PD  = Feat2PDMat(p,foi);
    save(['~/pi/PDmats/Baseline_1D_SubInd_' mat2str(nF) 'Fix_' mat2str(nfix) ],'PD')
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RUN OVER INDIVIDUAL SUBJECTS
clear all
load ~/pi/tmp/SelectedFeatures.mat
%foi = {foi{1:15}};
foi{17} = 'FixMap_FixmatInd_2_FWHM_45';
foi = PrepFeatCell(foi);    
for nF = 1:48
    p   = GetParameters('nBin',64,'FixmatInd',2,'subjects',nF);        
    CondProb(p,foi);
    PD  = Feat2PDMat(p,foi);
    save(['~/pi/PDmats/Baseline_1D_subject' mat2str(nF)],'PD');
end
%make a PDmat with all the subjects
for nF = 1:48
    load(['~/pi/PDmats/Baseline_1D_subject' mat2str(nF)],'PD');
    %we will add all the remaining PDs to PD2
    if nF == 1;
        PD2 = PD;
    else
        PD2.A.mean = cat(4,PD2.A.mean,PD.A.mean);
        PD2.C.mean = cat(4,PD2.C.mean,PD.C.mean);
        PD2.DKL.d  = cat(3,PD2.DKL.d,PD.DKL.d);
    end
end
PD = PD2;
save(['~/pi/PDmats/Baseline_1D_subjectALL_FeatureALL'],'PD');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Non-POOLED 1D case Bin 64 (for the 1D case); NONWEIGHTED, SIGNIFICANCE
% TEST WITH RANDOM FIXMATS

clear all
    load ~/pi/tmp/SelectedFeatures.mat
    foi = PrepFeatCell(foi);
for nF = 52;
    %we run the random realizations with the same number of fixations as
    %the real-observation, that is the reason why we use a randomly chosen 
    %single subject.
    p   = GetParameters('nBin',64,'FixmatInd',nF+12,'subject',randsample(1:48,1));
    f   = CondProb(p,foi)
    PD  = Feat2PDMat(p,foi);
    save(['~/pi/PDmats/Baseline_1D_rand' mat2str(nF)],'PD');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%RUN THE SAME THING WITH ITTI's FIXATIONS
clear all
p   	   = GetParameters('nBin',64,'fixs',1,'fixe',15,'FixmatInd',5);%here we take the first fixation
load ~/pi/tmp/SelectedFeatures.mat
foi = PrepFeatCell(foi);
%foi = fliplr(foi);
CondProb(p,foi)
PD = Feat2PDMat(p,foi)
save(['~/pi/PDmats/Baseline_1D_Itti'],'PD');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% POOLED 2D case Bin 8 (for the 2D case); NONWEIGHTED 
% WITHOUT CATEGORY DISTINCTION AND EXCLUDING PINK NOISE
clear all
p   = GetParameters('nBin',8,'CondInd',[1 192]);
load ~/pi/tmp/SelectedFeatures.mat;
foi = {foi{[1 2 3 4 14 9 5 8 7 6 11 16 17 ]}};%this specific order gives good colors on the figure
%foi = fliplr(foi);
[foi mat]= CombineFeatures(foi);
CondProb(p,foi);
PD = Feat2PDMat(p,mat);
save ~/pi/PDmats/Baseline_2D_NoCategory.mat PD
% Non-POOLED 2D case Bin 8 (for the 2D case); NONWEIGHTED
clear all
p   = GetParameters('nBin',8);
load ~/pi/tmp/SelectedFeatures.mat;
foi = {foi{[1 2 3 4 14 9 5 8 7 6 11 16 17 ]}};
[foi mat]= CombineFeatures(foi);
CondProb(p,foi);
PD = Feat2PDMat(p,mat);
save ~/pi/PDmats/Baseline_2D_WithCategory.mat PD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Non-POOLED 3D case Bin 4 (for the 3D case); NONWEIGHTED
clear all
p   = GetParameters('nBin',4);
load ~/pi/tmp/SelectedFeatures.mat;
foi = CombineFeatures3D(foi);
CondProb(p,foi);
PD = Feat2PDMat(p,mat);
save ~/pi/PDmats/Baseline3D.mat PD


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Non-POOLED 1D case Bin 20; LEFT VS RIGHT
clear all
p   = GetParameters('nBin',20,'FixmatInd',3);
load ~/pi/tmp/SelectedFeatures.mat
foi = PrepFeatCell(foi);
CondProb(p,foi)
%
clear all
p   = GetParameters('nBin',20,'FixmatInd',4);
load ~/pi/tmp/SelectedFeatures.mat
foi = PrepFeatCell(foi);
CondProb(p,foi)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SARAH: Non-POOLED 1D case Bin 20; LEFT VS RIGHT
clear all
load ~/pi/tmp/SelectedFeatures.mat
foi = PrepFeatCell(foi);
%RIGHT_NORMAL
opt = {'end',1000}
p   = GetParameters('nBin',20,'FixmatInd',9,opt{:});%right
CondProb(p,foi);
pd_sarah_Nright_1000 = Feat2PDMat(p, foi);
%LEFT_NORMAL
p   = GetParameters('nBin',20,'FixmatInd',8,opt{:});%left
CondProb(p,foi);
pd_sarah_Nleft_1000= Feat2PDMat(p, foi);
%RIGHT_MIRRORED
indices = p.CondInd;
p   = GetParameters('nBin',20,'FixmatInd',9, 'CondInd', indices+255,opt{:});%right
CondProb(p,foi);
pd_sarah_Mright_1000 = Feat2PDMat(p, foi);
%LEFT_MIRRORED
p   = GetParameters('nBin',20,'FixmatInd',8, 'CondInd', indices+255,opt{:});%left
CondProb(p,foi);
pd_sarah_Mleft_1000 = Feat2PDMat(p, foi);
%
save ~/pi/PDmats/sarah_1000 pd_sarah_Mleft_1000 pd_sarah_Mright_1000 pd_sarah_Nleft_1000 pd_sarah_Nright_1000

















%%%%%%%%%%%%%%%%% POOLED 1D case Bin 4 all features;
clear all
p   	   = GetParameters('pooled',1,'nBin',4);
load ~/pi/tmp/SelectedFeatures_extended.mat
CondProb(p,f)
Feat2PDMat(p,f);
% POOLED 1D case Bin 4;
clear all
p   	   = GetParameters('pooled',1,'nBin',4);
load ~/pi/tmp/SelectedFeatures.mat
Feat2PDMat(p,f);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% POOLED 1D Case Bin 64 (USE ITTI's FIXMAT)
clear all
p   	   = GetParameters('pooled',1,'nBin',64,'fixs',1,'fixe',15,'FixmatInd',5);%here we take the first fixation
load ~/pi/tmp/SelectedFeatures_extended.mat
CondProb(p,f)
PD = Feat2PDMat(p,f)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
% POOLED 2D case, Bin 20;
%clear all
%p         = GetParameters('pooled',1);
%load ~/pi/tmp/SelectedFeatures_extended.mat
%[foi2 m2] = CombineFeatures(foi)
%CondProb(p,foi2);
%PD        = Feat2PDMat(p,m2);	
% POOLED 2D case Bin 4, extended features;
clear all
p          = GetParameters('pooled',1,'nBin',4);
load ~/pi/tmp/SelectedFeatures_extended.mat
[foi2 m2]  = CombineFeatures(foi);
CondProb(p,m2)
PD        = Feat2PDMat(p,m2);	
% POOLED 2D case Bin 8, extended features;
%clear all
%p          = GetParameters('pooled',1,'nBin',8);
%load ~/pi/tmp/SelectedFeatures_extended.mat
%[foi2 m2]  = CombineFeatures(foi);
%CondProb(p,m2)
%PD         = Feat2PDMat(p,m2);	
%
% POOLED 2D case Bin 4 ;
clear all
p          = GetParameters('pooled',1,'nBin',4);
load ~/pi/tmp/SelectedFeatures.mat
[foi2 m2]  = CombineFeatures(foi);
PD        = Feat2PDMat(p,m2);	
% POOLED 2D case Bin 8;
%clear all
%p          = GetParameters('pooled',1,'nBin',8);
%load ~/pi/tmp/SelectedFeatures.mat
%[foi2 m2]  = CombineFeatures(foi);
%PD         = Feat2PDMat(p,m2);	
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%1D TIME BASED ANALYSIS Bin 4
clear all
load ~/pi/tmp/SelectedFeatures_extended.mat
for nBin = [ 4 8 64]
for X = 1:14;
	p  = GetParameters('pooled',1,'nBin',nBin,'fixs',X,'fixe',X+1);
	CondProb(p,f)
	PD = Feat2PDMat(p,f);	
end
end
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%3D case Bin 4
clear all
p          = GetParameters('pooled',1,'nBin',4);
load ~/pi/tmp/SelectedFeatures.mat
[foi3 m3]  = CombineFeatures3D(foi)
CondProb(p,foi3);
PD         = Feat2PDMat(p,m3);	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%3D case Bin 20
%clear all
%p          = GetParameters('pooled',1);
%load ~/pi/tmp/SelectedFeatures_extended.mat
%[foi3 m3]  = CombineFeatures3D(foi)
%CondProb(p,foi3)
%PD         = Feat2PDMat(p,m3);	
%
%3D case Bin 8
%clear all
%p          = GetParameters('pooled',1,'nBin',8);
%load ~/pi/tmp/SelectedFeatures_extended.mat
%[foi3 m3]  = CombineFeatures3D(foi)
%CondProb(p,foi3);
%PD         = Feat2PDMat(p,m3);	
%
%
