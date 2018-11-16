f = {
'LUM_IntDim_2_prestd_3_std_45'
'LUM_IntDim_1_prestd_3_std_10'
'LUM_IntDim_0_prestd_3_std_45'
'LUM_PC_EDGE_WL_24'
'LUM_PC_CORNER_WL_24'
'RG_C_Radius_45'
'LUM_C_Radius_45'
'SAT_C_Radius_45'
'YB_C_Radius_45'
'LUM_PS_WL_24'
'LUM_C_Radius_45_C_Radius_135'
'LUM_C_Radius_45_C_Radius_225'
'RG_M_Radius_91'
'LUM_M_Radius_91'
'SAT_M_Radius_91'
'YB_M_Radius_91'
}

p   = GetParameters('pooled',0);
[D] = View_PostFit_1D(f,p,1);
%PLOT AVERAGE DELTA H
dummy = D.d(:,3:end,end)';
errorbar( mean(dummy) , std(dummy)./sqrt(size(dummy,1)) );
set(gca,'xtick',1:4,'xticklabel',{'N' 'F' 'U' 'P'});
ylabel('\Delta H');grid on
exportfig(gcf,['~/project_Integration/matlab/condprob/latex/AverageDeltaH'],'format','png','FontSizeMin',10,'Bounds','loose');
%
%
%Plot the analysis results
D_all = View_PostFit_1D({f{3:end}},p,1);
exportfig(gcf,['~/project_Integration/matlab/condprob/latex/1D_PostDist_SummaryFigure.png'],'format','png','FontSizeMin',10,'Bounds','loose');
%
%
%Plot the analysis results for clik maps and feature maps
D_cmfm = View_PostFit_1D({f{1:2}},p,1);
exportfig(gcf,['~/project_Integration/matlab/condprob/latex/1D_PostDist_SummaryFigure_FM_CM.png'],'format','png','FontSizeMin',10,'Bounds','loose');
%
%
%Plot clickmap delta h against fixmap delta h.
plot(D_cmfm.d(1,2,end),D_cmfm.d(1,1,end),'og','markersize',15);
hold on
plot(D_cmfm.d(2,2,end),D_cmfm.d(2,1,end),'or','markersize',15);
plot(D_cmfm.d(3,2,end),D_cmfm.d(3,1,end),'ok','markersize',15);
DrawIdentityLine(gca)
legend({'natural','fractal','urban'})
axis tight
xlabel('fixmap (\Delta H)');
ylabel('clickmap (\Delta H)');
exportfig(gcf,['~/project_Integration/matlab/condprob/latex/1D_PostDist_FM_vs_CM.png'],'format','png','FontSizeMin',10,'Bounds','loose');
%
%
View_PostDist_1D({f{1:2}},p);
exportfig(gcf,['~/project_Integration/matlab/condprob/latex/1D_PostDist_FMCM_curves.png'],'format','png','FontSizeMin',10,'Bounds','loose');
%
%
m{1} = FMapEntVSFeatEnt(f,1:64,1);
m{2} = FMapEntVSFeatEnt(f,65:128,1);
m{3} = FMapEntVSFeatEnt(f,129:192,1);
m{4} = FMapEntVSFeatEnt(f,193:255,1);
colors = {'g' 'r' 'k' 'm'};
for x = 1:4
r= corrcoef(vertcat(m{x}(:).ent_feat)');
r= r(2,:);
r(2) =[];%remove the diagonal entry;
plot(r.^2 , 1:(length(r)),'o-','color',colors{x},'linewidth',4);
hold on
end
grid on
set(gca,'ytick',1:19,'yticklabels',{m{1}([1 3:end]).feature})
xlabel('r^2')
legend('natural','fractal','urban','pink')
hold off
exportfig(gcf,['~/project_Integration/matlab/condprob/latex/FixVSFeatEntropy.png'],'format','png','FontSizeMin',10,'Bounds','loose');

figure;
plot( m{1}(3).ent_fix , m{1}(3).ent_feat , 'o');
hold on
plot( m{1}(8).ent_fix , m{1}(8).ent_feat , '.r');
hold off
legend('LC','IntDim_2');
xlabel('fixmap Ent');
ylabel('featmap_ent');
exportfig(gcf,['~/project_Integration/matlab/condprob/latex/FixVSFeatEntropy_Ex.png'],'format','png','FontSizeMin',10,'Bounds','loose');













