 
%ANKE BUSINESS
cd ~/pi/EyeData/EDF/
sub = ListFiles('*.EDF');
fixmat_anke_ = [];
for i = 1:length(sub)       
    i
    [a b]            = edfread(sub{i},'IMG');
    fixmat_          = fixations_foranke(a,b);
    fixmat_.subject  = repmat(i,1,length(fixmat_.start));
    fixmat_anke_     = [fixmat_anke_ fixmat_];
end
%merge fixmats
fi = fields(fixmat_anke_);
clear fixmat_anke
for f = 1:length(fi)
    if ~strcmp(fi{f},'IMG')        
        fixmat_anke.(fi{f}) = [ fixmat_anke_(:).(fi{f}) ];                               
    end
end
clear fixmat_anke_ fixmat_
fixmat_anke.rect =[0 960 0 1280];
fixmat_anke.source = repmat(1,1,length(fixmat_anke.calib_aveerror));


% STEFFEN BUSINESS
cd /net/space/users/swaterka/DiffCat_Baseline1_contd/DATA
sub = ListFiles('*.EDF');
fixmat_steffen_ = [];
for i = 1:length(sub)       
    i
    [a b]            = edfread(sub{i});
    fixmat_          = fixations(a,b);       
    fixmat_.subject  = repmat(i,1,length(fixmat_.start));
    fixmat_steffen_  = [fixmat_steffen_ fixmat_];
end
clear fixmat_steffen;
fi = fields(fixmat_steffen_);
for f = 1:length(fi)
    if ~strcmp(fi{f},'IMG')        
        fixmat_steffen.(fi{f}) = [ fixmat_steffen_(:).(fi{f}) ];                               
    end
end
clear fixmat_steffen_ fixmat_
fixmat_steffen.rect      = [0 960 0 1280];
fixmat_steffen.image     = double(fixmat_steffen.index);
fixmat_steffen           = rmfield(fixmat_steffen,{'index','SUBJECTINDEX'});
fixmat_steffen.condition = ceil(fixmat_steffen.image./64);
fixmat_steffen.source    = repmat(2,1,length(fixmat_steffen.calib_aveerror));


%MERGE and CLEAN
fixmat_  = [];
fi      = fields(fixmat_steffen);
for f = 1:length(fi)        
    if strcmp((fi{f}),'subject')
        fixmat_steffen.subject = [ fixmat_steffen.subject+max(unique(fixmat_anke.subject))];
    end
    fixmat_.(fi{f}) = [ fixmat_anke.(fi{f}) fixmat_steffen.(fi{f}) ];        
end
%
fixmat_.x = round(fixmat_.x);
fixmat_.y = round(fixmat_.y);
%
selection = ~(fixmat_.x <= fixmat_.rect(3) | fixmat_.x > fixmat_.rect(4) | fixmat_.y <= fixmat_.rect(1) | fixmat_.y > fixmat_.rect(2));%selection is a logical array containing the indices of the fixations to be deleted
fixmat = []
for f = 1:length(fi)     
     if ~strcmp(fi{f},'rect')   
        fixmat.(fi{f}) = [ fixmat_.(fi{f})(selection) ];                                           
     end
end
fixmat.rect =[0 960 0 1280];





