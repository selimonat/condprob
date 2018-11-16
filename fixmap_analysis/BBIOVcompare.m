%this figures are in IOV.pdf
%COMPARE IOV OF CLICKMAPS AND FIXMAPS
load ~/pi/clickmat.mat;
clickmat.fix = repmat(2,1,length(clickmat.x));
fixmat = GetFixMat(1);
%
a.kernel     = 1;
a.bf         = 64
a.CropAmount = 0
%
p = GetParameters
%
for nc = 1:4
    im = p.CondInd(nc,1):p.CondInd(nc,2);

    [r(nc).click]   = IOV(clickmat,im,a);
    %
    fixmat = GetFixMat(1)
    [r(nc).fix]    = IOV(fixmat,im,a);
    %
end

%PLOT THE RESULTS
color = {'g' 'r' 'k' 'm'}
figure('position',[0 0 700 700])
for nc = 1:4
    plot(mean(r(nc).fix),mean(r(nc).click),'o','Markerfacecolor',color{nc},'MarkerEdgeColor',color{nc},'markersize',8)
    hold on
end
DrawIdentityLine(gca);
xlabel('IOV fixation map (r)')
ylabel('IOV click map (r)')
title('Relation of IOV_{CM} VS IOV_{FM}')
axis square
legend('Nat','Frac','Urban')
SaveFigure('~/pi/matlab/condprob/latex/IOV_CM_VS_IOV_FM');
%
%
%compute the entopy of the fixation maps
[h.fix]=FixMapEntropy(fixmat,p.kernel,0,2);
%PLOT the RESULTs of the IOV analysis
figure('position',[0 0 1600 700 ])
for x = 1:4
    %
    subplot(3,4,x)
    imagesc(r(x).fix,[0 1])
    title(['IOV_{cat: ' mat2str(x) '}']);
    colorbar
    xlabel('image')
    ylabel('bs #')
    %
    subplot(3,4,x+4)
    hist(r(x).fix(:),400)
    xlim([0 1])       
    %
    %Here we compare the entropy of the fixation maps to the IOV    
    subplot(3,4,x+8)
    plot(mean(r(x).fix),h.fix(x).a,'o')
end
%
SaveFigure('~/pi/matlab/condprob/latex/IOV_hist');
