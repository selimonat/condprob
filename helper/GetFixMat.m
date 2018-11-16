function [fixmat] = GetFixMat(i)
%[fixmat] = GetFixMat(i)
%Loads the fixmat of Anke's experiment if I is equal to 1.

if i == 1;
    load ~/pi/EyeData/fixmat_all_minus_7_10.mat;
    %for this fixmat we will discard the data of subjects 18 and 20. The
    %reason is that these subjects have their 1st fixations (which is
    %supposed to be centrally located) off set from all the other people's
    %1st fixation. 18 and 20 do not correspond to the subject indices in
    %the Anke's thesis but to the fixmat indices. This indices must be
    %equalized one day and the best decision for this is the time when
    %Steffen will collect new data.
    fixmat.rect = [ 0 960 0 1280];
    %
    fixmat = SelectFix(fixmat,'subject',[1:17 19 21:25]);
    %
elseif i == 2%BASELINE 
    load ~/pi/EyeData/fixmat_baseline.mat;    
    fixmat.rect = [ 0 960 0 1280];        
elseif i == 3%BASELINE LEFT
    load ~/pi/EyeData/fixmat_baseline_left.mat;    
    fixmat.rect = [ 0 960 0 1280];
elseif i == 4 %BASELINE RIGHT
    load ~/pi/EyeData/fixmat_baseline_right.mat;    ;
    fixmat.rect = [ 0 960 0 1280];
    
elseif i == 5 %itti's fixmat;
    load ~/pi/EyeData/fixmat_itti.mat;
    fixmat.rect = [ 0 960 0 1280];
    
elseif i == 6 %sarah's fixmat (left-right flip project);
    load ~/pi/EyeData/fixmat_sarah.mat;
    fixmat.rect = [ 0 960 0 1280];
elseif i == 7 %same as 6 but corrected for flips and merged conditions (adaptsarahfixmat.m);
    load ~/pi/EyeData/fixmat_sarah_adapted.mat;
    fixmat.rect = [ 0 960 0 1280];
    
    
elseif i == 8 %same as 6 but corrected for flips and merged conditions (adaptsarahfixmat.m);
    load ~/pi/EyeData/fixmat_sarah_adapted_left.mat;
    fixmat.rect = [ 0 960 0 1280];
elseif i == 9 %same as 6 but corrected for flips and merged conditions (adaptsarahfixmat.m);
    load ~/pi/EyeData/fixmat_sarah_adapted_right.mat;
    fixmat.rect = [ 0 960 0 1280];
    
    
elseif i == 10 %steffen's anke's cont.;
    load ~/pi/EyeData/fixmat_steffen.mat;
    fixmat.rect = [ 0 960 0 1280];
elseif i == 11 %steffen and anke's fixmat combined.;
    load ~/pi/EyeData/fixmat_steffen_combi.mat;
    fixmat.rect = [ 0 960 0 1280];
elseif i == 12
    load ~/pi/EyeData/fixmat_joseTMS.mat;
    fixmat.rect = [ 0 1200 0 1600];
elseif i > 12
    i
    load(['~/pi/EyeData/fixmat_baseline_randomized_' mat2str(i-12) '.mat']);    
end

