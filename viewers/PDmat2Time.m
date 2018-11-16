PDmat2Time

for X = 1:14;
    p  = GetParameters('pooled',1,'nBin',4,'fixs',X,'fixe',X+1);
    pdt(X) = Feat2PDMat(p,f);
end

%
DKL = [pdt(:).DKL];
DKL= vertcat(DKL(:).d);
%
figure(1)
subplot(1,2,1)
plot(DKL(:,[1:15 18]),'o-')
xlabel fixation
subplot(1,2,2)
imagesc(zscore(DKL(:,[1:15 18]))')
set(gca,'ytick',1:18,'yticklabel',{pdt(1).feat_short{[1:15 18]}})
xlabel fixation
%
figure(2)
subplot(1,2,1)
plot(DKL(:,16:17),'o-')
xlabel fixation
subplot(1,2,2)
imagesc(zscore(DKL(:,16:17))')
set(gca,'ytick',1:3,'yticklabel',{pdt(1).feat_short{16:17}})
xlabel fixation
%make a linear fit
[y]=lscov([ones(14,1) (1:14)'],DKL);