function [ent,ranked,i]=View_DeltaEntropy_1D(f)
%[ent,ranked]=View_DeltaEntropy_1D(f)
%
%
%F is the posterior distribution files. This function plots for each
%posterior distribution file the decrease in the entropy from control
%distribution to the actual distribution. ENT is the delta entropy which is
%plotted. It matches to the cell array F. RANKED is the ordered F with
%respect to the entropies. I is the indices to order F into RANKED. Please
%note that in the case of more than one category (f is two dimensional) the
%sorting is wrong, because the function does not now on which category to
%rely on for sorting. Therefore it is recommended to provide a sorted F in
%such cases and ignore the second figure which presents the ordered points.
%
%Selim, 11-Feb-2008 17:52:50

if size(f,1) < size(f,2) 
    display('Results are probably wrong \n F must be a column vector.')
end

if size(f,2) > 1
    display('Ignore the second figure.')
end

tcat = size(f,2);
tf   = size(f,1);
%
for nf = 1:tf
    for nc = 1:tcat
        %
        load(['~/project_Integration/PostFit/' f{nf,nc}]);
        feat{nf}    = res.feature{1};
        ent(nf,nc)  = res.entropy.C.MeanPDF - res.entropy.A.MeanPDF;
        %
        conds{nc}   = SummarizeVector(res.im);
    end
end

figure('position',[0 0 700 500])
plot(ent,1:tf,'o-');
set(gca,'ytickLabel',{feat{:}},'ytick',1:tf);
grid on
xlabel('\Delta H (bits)')
title(conds)
%axis([0 0.1 0 tf])
legend(conds)
%
%
figure('position',[0 0 700 500])
[y i] = sort(ent,'ascend');
plot(y,1:tf,'o-')
set(gca,'ytickLabel',{feat{i}},'ytick',1:tf);
grid on
xlabel('\Delta H (bits)')
title(conds)
%axis([0 0.1 0 tf])
legend(conds,'location','SouthEast')
%
%
%prepare output
%in case of multi categories we simply focus on the first category for
%sorting
i = repmat(i(:,1),1,tcat);
%
ranked = reshape({f{i}},tf,tcat);