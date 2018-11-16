%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%computes the mutual information between pair of features.
load ~/pi/tmp/SelectedFeatures.mat
PDmat = Feat2PDMatrix(foi,'_Im_\\[1:192\\]');
tFeat = length({PDmat{:}});
for i = 1:tFeat;
    i
    load(['~/pi/PostFit/' PDmat{i}]);
    FeatFeat(i) = res.entropy.C.MaxEntropy - res.entropy.C.MeanPDF;    
end
%cancel the diagonals.
FeatFeat(1:sqrt(tFeat)+1:end) = NaN;
%
FeatFeat = (reshape(FeatFeat,[sqrt(tFeat) sqrt(tFeat)]));
figure('position',[0 0 600 600])
imagesc(FeatFeat)
set(gca,'ytickLabel',foi,'ytick',1:sqrt(tFeat),'xtick',1:sqrt(tFeat));
axis square
colorbar
VerticalXlabel(foi,'interpreter','none');
SaveFigure('~/pi/matlab/condprob/latex/2D_PFeature_MI');

%feature pairs with highest dependence
[y i] =sort(FeatFeat(:))
PDmat{i(end-16:-2:end-36)}
%feature pairs with lowest dependence
PDmat{i(1:2:36)}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%COMPUTE THE DELTA ENTROPY AS WE DO IT IN THE 2D CASE.
load ~/pi/tmp/SelectedFeatures.mat
PDmat = Feat2PDMatrix(foi,'_Im_\\[1:192\\]');
tFeat = length({PDmat{:}});
for i = 1:tFeat;
    i
    load(['~/pi/PostFit/' PDmat{i}]);
    d.C(i) = res.entropy.C.MeanPDF;    
    d.A(i) = res.entropy.A.MeanPDF;    
end
figure('position',[0 0 600 600])
imagesc(reshape(d.A-d.C,sqrt([tFeat tFeat])))
set(gca,'ytickLabel',foi,'ytick',1:sqrt(tFeat),'xtick',1:sqrt(tFeat));
axis square
colorbar
VerticalXlabel(foi,'interpreter','none');
SaveFigure('~/pi/matlab/condprob/latex/2D_FeatFix');
%THE SAME DATA AFTER CANCELING THE NEGATIVE VALUES.
figure('position',[0 0 600 600])
imagesc(abs(reshape(d.A-d.C,sqrt([tFeat tFeat]))))
set(gca,'ytickLabel',foi,'ytick',1:sqrt(tFeat),'xtick',1:sqrt(tFeat));
axis square
colorbar
VerticalXlabel(foi,'interpreter','none');
SaveFigure('~/pi/matlab/condprob/latex/2D_FeatFix_abs');
%%list the strongest pairs
[y i] =sort(abs(d.A-d.C))



