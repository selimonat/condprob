function [fixmat]=IttiSfixmat(fixations);
%Fixations is the output of batchSaliency of itti's toolbox. The results of
%his toolbox are stored in IttiResults.mat.


fixmat.x         = [];
fixmat.y         = [];
fixmat.fix       = [];
fixmat.image     = [];
fixmat.condition = [];
fixmat.subject   = [];
fixmat.start     = [];
fixmat.end	     = [];
for nf = 1:length(fixations)
    tfix             = length(fixations{nf});
    cond             = ceil(nf/64);%detect condition index;
    fixmat.x         = [fixmat.x fixations{nf}(:,2)'];
    fixmat.y         = [fixmat.y fixations{nf}(:,1)'];
    fixmat.fix       = [fixmat.fix 1:tfix];
    fixmat.image     = [fixmat.image repmat(nf,1,tfix)];
    fixmat.condition = [fixmat.condition repmat(cond,1,tfix)];
    fixmat.subject   = [fixmat.subject repmat(1,1,tfix)];
	fixmat.start     = [fixmat.start repmat(100,1,tfix)];
	fixmat.end	     = [fixmat.end repmat(100,1,tfix)];
end
fixmat.rect = [0 960 0 1280];
