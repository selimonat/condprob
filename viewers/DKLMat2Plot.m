function [out]=DKLMat2Plot(PDmat);

%For each feature pair COmpute the expected DKL measurement from the sums
%of the 1D feature DKLs.

%make the feature list
list = diag(PDmat.feat);
for x=1:length(list);foi{x}=list{x}{1};end
foi = shortfeat(foi);
%
tfeat = length(list);
%make the model
DKL = (PDmat.DKL.C2A + PDmat.DKL.A2C)./2;
tCond = size(DKL,1);
model = repmat(diag(DKL),1,tCond) + repmat(diag(DKL)',tCond,1);
%detect cmap limits
cmap = [min([model(:); DKL(:)])   max([model(:) ;DKL(:)]) ];
%
subplot(1,3,1);
imagesc(DKL,cmap);
hold on
plot([0 tfeat+0.5],[0 tfeat+0.5],'w')
set(gca,'ytickLabel',foi,'ytick',1:tfeat,'xtick',1:tfeat);
VerticalXlabel(foi,'interpreter','none');
grid on
axis square
colorbar
%
%
subplot(1,3,2);
imagesc(model,cmap);
hold on
plot([0 tfeat+0.5],[0 tfeat+0.5],'w')
set(gca,'ytick',1:tfeat,'xtick',1:tfeat,'ytickLabel',foi);
VerticalXlabel(foi,'interpreter','none');
axis square
grid on
colorbar
%
subplot(1,3,3);
xlabel('model (DKL)');
ylabel('empirical (DKL)')
axis square
%
title('Binary matrix showing features with DKL > model');
imagesc(DKL > model )
hold on
plot([0 tfeat+0.5],[0 tfeat+0.5],'w')
set(gca,'ytick',1:tfeat,'xtick',1:tfeat,'ytickLabel',foi);
VerticalXlabel(foi,'interpreter','none');
axis square
grid on
%
out.d = DKL;
out.model = model;