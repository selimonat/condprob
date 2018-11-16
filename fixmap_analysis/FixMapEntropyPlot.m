%FixMapEntropy_plot

h.a(4,64) = NaN;

ave = nanmean(h.a,2);
med = nanmedian(h.a,2);
sem = nanstd(h.a')./8;
%
errorbar(ave,sem,'o-','markersize',20);
hold on
%
plot(med,'r+-','markersize',20);
plot(h.c,'ko-','markersize',20);
set(gca,'xtick',1:4,'xticklabel',{'N' 'F' 'U' 'P'})
grid on;
axis square
xlabel('category');
ylabel('entropy');
title('analysis of fixation maps');
legend('Average','Median','Maximum');
axis square
% SaveFigure('/HardDick/project_Integration/Analysis/FixMapAnalysis/FixMapEntropy','FontSizeMin',12)