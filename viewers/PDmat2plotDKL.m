function PDmat2plotDKL(PDmat)
%PDmat2plotDKL(PDmat)
%
%Shows DKL values as a horizontal bar plots.
%
%Selim


%number of different features
tFeat = length(PDmat.feat_short);

%GET THE DATA FROM MANY DIMENSIONAL RESULTS INTO A COMMON SHAPE
if PDmat.nDimen == 1
    data  = PDmat.DKL.d;
    label = PDmat.feat_short_mat;
elseif PDmat.nDimen == 2    
    [y x ] = ind2sub([tFeat,tFeat],1:tFeat.^2);
    i = x<=y;    
    data = data(i);
    %
    label = {PDmat.feat_short_mat{i}};
    %
elseif PDmat.nDimen == 3;
    [y x z] = ind2sub([tFeat,tFeat,tFeat],1:tFeat.^3);
    index = [z;y;x]';
    i    = (index(:,2) >= index(:,3)) & (index(:,1) >= index(:,2));
    
    data = squeeze(PDmat.DKL.d(index));
    data = data(i);
    %
    label = {PDmat.feat_short_mat{i}};
    %
end
%
tCombination = length(data);
%
%PLOT IT
figure;
set(gcf,'position',[0 0 1280 500])
subplot(1,2,1);
barh(data,'k');
set(gca,'ytick',1:tCombination,'yticklabel',label)
xlabel('average DKL (bits)')
set(gca,'xgrid','on')
title('Feature-Fixation Correlation Strength')
axis tight
subplotChangeSize(gca,0,0.1)
%
subplot(1,2,2);
[y i]= sort(data);
barh(data(i),'k');
set(gca,'ytick',1:tCombination,'yticklabel',{label{i}})
xlabel('average DKL (bits)')
set(gca,'xgrid','on')
title('Feature-Fixation Correlation Strength (sorted)')
axis tight
subplotChangeSize(gca,0,0.1)