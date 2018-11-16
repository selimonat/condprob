% 
% 
p = GetParameters;
FixmatInd = 6;
RF      = p.bf    ;%resize Factor of the fixation maps
fark_ga = MirrorEffect(FixmatInd,{ {'fix' 1 } {'fix' 2} {'fix' 3} {'fix' 4:20}}); 
% 
% GRAND TOTAL HORIZONTAL
figure(1);
hold off;
color = {'r' 'g' 'b' 'k'};
tPart = size(fark_ga.h,2);
set(gcf,'position',[1681 995 1680 399]);
for npart = 1:tPart;    
    level = min(fark_ga.bs.h_ci99(:,npart,1))+min(fark_ga.bs.h_ci99(:,npart,1))*0.1;        
    
%     HORIZONTAL AXIS
    subplot(2,tPart,npart)
    plot(fark_ga.h(:,npart),'k' );
    area(fark_ga.bs.h_ci99(:,npart,2),level,'facecolor',color{npart},'edgecolor','none');
    hold on
    area(fark_ga.bs.h_ci99(:,npart,1),level,'facecolor','w','edgecolor','none');
    plot([0 size(fark_ga.h,1)],[0 0],'k');
    plot([size(fark_ga.h,1)/2 size(fark_ga.h,1)/2],[get(gca,'yLim')],'k');
    xlabel('horizontal axis')
    title(cell2str(fark_ga.d{npart}),'interpreter','none');
    box off
    
%     VERTICAL AXIS
    level = min(fark_ga.bs.v_ci99(:,npart,1))+min(fark_ga.bs.v_ci99(:,npart,1))*0.1;        
    subplot(2,tPart,npart+tPart)
    plot(fark_ga.v(:,npart),'k' )
    area(fark_ga.bs.v_ci99(:,npart,2),level,'facecolor',color{npart},'edgecolor','none');
    hold on
    area(fark_ga.bs.v_ci99(:,npart,1),level,'facecolor','w','edgecolor','none');
    plot([0 size(fark_ga.v,1)],[0 0],'k');
    plot([size(fark_ga.v,1)/2 size(fark_ga.v,1)/2],[get(gca,'yLim')],'k');    
    xlabel('vertical axis')    
    box off
end
% print('-dpng',[p.Base 'MirrorEffect_plot/GrandAverage_VH'])
% print('-depsc',[p.Base 'MirrorEffect_plot/GrandAverage_VH'])
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAND TOTAL 2D
figure(3);
set(gcf,'position',[1681   915   444   919]);
fixmat = GetFixMat(FixmatInd);
for npart = 1:tPart
    f0 = (fixmat2fixmap(fixmat,p.kernel,0,RF,'www','condition',0,fark_ga.d{npart}{:}));
    f1 = fliplr(fixmat2fixmap(fixmat,p.kernel,0,RF,'www','condition',1,fark_ga.d{npart}{:}));
    subplot(tPart,1,npart)
    imagesc(f0-f1)
    hold on
    title(cell2str(fark_ga.d{npart}),'interpreter','none');
    colorbar
    plot([0 fixmat.rect(4)/RF],[fixmat.rect(2)/RF/2 fixmat.rect(2)/RF/2],'k--')

    plot([fixmat.rect(4)/RF/2 fixmat.rect(4)/RF/2],[0 fixmat.rect(2)/RF],'k--')  
    title(cell2str(fark_ga.d{npart}),'interpreter','none');
    axis off
    axis image
    drawnow
end
print('-dpng',[p.Base 'MirrorEffect_plot/GrandAverage_2D'])
print('-depsc',[p.Base 'MirrorEffect_plot/GrandAverage_2D'])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% GENDER SPECIFIC DIFFERENCES
% 0 is MALE
% 1 is FEMALE
fark_gender = MirrorEffect(FixmatInd,{ {'fix' 1 'gender' 0} {'fix' 2 'gender' 0} {'fix' 3 'gender' 0} {'fix' 1 'gender' 1 } {'fix' 2 'gender'  1} {'fix' 3 'gender' 1}})
figure(4);
tPart = size(fark_gender.h,2);
for npart = 1:tPart/2;    
    
    
    subplot(1,tPart/2,npart)
    plot(fark_gender.h(:,npart),'k' ,'linewidth',1.5);%males
    hold on
    plot(fark_gender.h(:,npart+tPart/2),'m','linewidth',1.5);%females
    
    female
    lower_m  = fark_gender.bs.h_ci99(:,npart,1);
    higher_m = fark_gender.bs.h_ci99(:,npart,2);
    male
    lower_f  = fark_gender.bs.h_ci99(:,npart+tPart/2,1);
    higher_f = fark_gender.bs.h_ci99(:,npart+tPart/2,2);
    
    jbfill(1:size(fark_gender.h,1), lower_m' ,higher_m' , 'k','k',0,0.5)    
    jbfill(1:size(fark_gender.h,1), lower_f' ,higher_f' , 'm','m',0,0.5)
    
    plot the cross
    hold on
    plot([0 size(fark_gender.h,1)],[0 0],'k');
    plot([size(fark_gender.h,1)/2 size(fark_gender.h,1)/2],[get(gca,'ylim')],'k');
    axis tight
    legend('M','F');legend boxoff
    set(gca,'box','off')
    title(cell2str(fark_gender.d{npart}),'interpreter','none');
end
set(gcf,'position',[1681 995 1680 399]);

print('-dpng',[p.Base 'MirrorEffect_plot/Gender_H'])
print('-depsc',[p.Base 'MirrorEffect_plot/Gender_H'])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

CATEGORY SPECIFIC DIFFERENCES

selection = { {'fix' 1 'category' 1} {'fix' 2 'category' 1} {'fix' 3 'category' 1} {'fix' 3:20 'category' 1}; ...
{'fix' 1 'category' 2} {'fix' 2 'category' 2} {'fix' 3 'category' 2} {'fix' 3:20 'category' 2}; ...
{'fix' 1 'category' 3} {'fix' 2 'category' 3} {'fix' 3 'category' 3} {'fix' 3:20 'category' 3}; ...
{'fix' 1 'category' 4} {'fix' 2 'category' 4} {'fix' 3 'category' 4} {'fix' 3:20 'category' 4}};





figure(5);
set(gcf,'position',[1681   878   1680 885]);
hold off
tCat  = size(selection,1);
tPart = size(selection,2);
fixmat = GetFixMat(FixmatInd);
tPix  = fixmat.rect(4)./RF;
color = {'r' 'g' 'b' 'm'};
cat   = {'Nat' 'Urban' 'Frac' 'Pink'}
c = 0;
for i = 1:length(selection);
    for nCat = 1:tCat
        for npart = 1:tPart;
            
            fark_category = MirrorEffect(FixmatInd,{selection{nCat,npart}});
            c = c+1;
            
            subplot(tCat , tPart ,c)
            plot(fark_category.h(:,1),'k' ,'linewidth',1.5);%males
            
            lower  = fark_category.bs.h_ci99(:,1,1);
            higher = fark_category.bs.h_ci99(:,1,2);
            
            jbfill(1:tPix, lower' , higher' , color{npart},'none',0,1)
%             jbfill([1:tPix tPix:-1:1, [lower'  higher'] , color{npart})
            
            if nCat == 1
                axis tight
                y(npart,:) = get(gca,'ylim');
                y(npart,:) = y(npart,:)*1.4;
                set(gca,'ylim',y(npart,:),'xlim',[1 tPix]);
            else
                set(gca,'ylim',y(npart,:),'xlim',[1 tPix]);
            end
            if mod(npart,tPart) == 1
                ylabel(cat{ceil(c./tCat)});
            end
            plot the cross
            hold on
            plot([0 tPix],[0 0],'k');
            plot([tPix/2 tPix/2],[y(npart,:)],'k');
            set(gca,'box','off')
            drawnow
            title(cell2str(fark_category.d{1}),'interpreter','none');
        end
    end
end
print('-dpng',[p.Base 'MirrorEffect_plot/Category_H'])
print('-depsc',[p.Base 'MirrorEffect_plot/Category_H'])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPACE TIME PLOTS:
RF            = 2; %resize factor of the final maps...
%GENERAL PARAMETERS
% smoothing kernel
kernel        = GetGauss(100);
kernel        = kernel./sum(kernel(:));
% EXPERIMENT SPECIFIC PARAMETERS
% for SARAH
SESS = {{'category' 1} {'category' 2} {'category' 3} {'category' 4}};
% TMS  = {{'gender' 0} {'gender' 1}};
TMS  = {{}};
FixmatInd = 7;
fixmat        = GetFixMat(FixmatInd);%sarah fixmat
TrialDuration = 6000./RF;
ImageWidth    = fixmat.rect(4)./RF;

% for JOSETMS
% % %
% % p = GetParameters;
% % TMS  = { {'tms' 0} {'tms' 1} {'tms' 3} {'tms' 2}};
% % SESS = { {'session' 1:3} {'session' 4:6}};
% % FixmatInd     = 12;%need to be changed if your index is different!!!
% % fixmat        = GetFixMat(FixmatInd);%sarah fixmat
% % ImageWidth    = fixmat.rect(4)./RF;
% % TrialDuration = 7000./RF;
%divide coordinates and time by RF
fixmat.x       = fixmat.x/RF;
fixmat.y       = fixmat.y/RF;
fixmat.start   = fixmat.start/RF;
fixmat.end     = fixmat.end/RF;
fixmat.rect(4) = fixmat.rect(4)/2;
%this is a half 1, half -1 matrix, the same size as SpaceTIme plots. We
%will use this to compute a Laterality Index.
mat = [ones([TrialDuration ImageWidth/2]) ones([TrialDuration ImageWidth/2]).*-1 ];
% IN THIS LOOP WE COMPUTE THE DATA IN THE NEXT LOOP WE WILL PLOT IT
D = [];%difference of STmaps
LI = [];%laterality index
c = 0;

% for nSUB = unique(fixmat.subject);
for nTMS = 1:length(TMS)%run over TMS 
    for nSESS = 1:length(SESS)%run over Sessions
        c =  c+ 1;
        
        selection = { TMS{nTMS}{:} SESS{nSESS}{:} };%selection criteria
        
        fixmat0 = SelectFix(fixmat,'condition',0,selection{:},'end',TrialDuration,'start',1);
%         jose's fixmat contains fixations which are later than Trial
%         duration, so we discard them with ,'end',TrialDuration. And we
%         discard few fixations which have 0 as 'start' point.
        fixmat1 = SelectFix(fixmat,'condition',1,selection{:},'end',TrialDuration,'start',1);
        
        dummy      = accumarray(ceil([double(fixmat0.start') double(fixmat0.x')]),1,[TrialDuration ImageWidth]);
        ST_c    = conv2(sum(kernel),sum(kernel,2),dummy,'same');
           
        dummy    = accumarray(ceil([double(fixmat1.start') double(fixmat1.x')]),1,[TrialDuration ImageWidth]);
        ST_M_c  = fliplr(conv2(sum(kernel),sum(kernel,2),dummy,'same'));%YOU MAY NOT NEED TO FLIP!!!!!
        ST_M_c  = (conv2(sum(kernel),sum(kernel,2),dummy,'same'));%YOU MAY NOT NEED TO FLIP!!!!!
          
        TM_c    = (ST_c - ST_M_c)./((ST_c+ST_M_c))*100;
    
        D(:,:,nTMS,nSESS)  = (ST_c - ST_M_c);
        LI(:,nTMS,nSESS)   = mean((ST_c - ST_M_c).*mat,2);
        
    end
end

% detect axis and colorbar limits.
thr = 1.5;
S = std(D(:));
M = mean(D(:));
UP = M+S*thr;DOWN= M-S*thr;

xmaxi = max(LI(:));
xmini = min(LI(:));
% PLOT THE GARBAGE!!


figure(1);figure(2);
set(1,'position',[1681 1 1680 924])
set(2,'position',[1681 1 1680 924])
c = 0;
for nTMS = 1:length(TMS)%run over TMS 
    for nSESS = 1:length(SESS)%run over Sessions
        c =  c+1;
   selection = { TMS{nTMS}{:} SESS{nSESS}{:} };%selection criteria
        figure(1);
        subplot(length(SESS),length(TMS),c)
        imagesc(D(:,:,nTMS,nSESS),[DOWN UP]);    
        hold on
        contour(D(:,:,nTMS,nSESS),[0 0],'k');
        title(cell2str(selection),'interpreter','none');        
               
%         embellish
        set(gca,'xtick',[0 round(ImageWidth/2) ImageWidth]);
        set(gca,'ytick',[0 round(TrialDuration/2) TrialDuration]);        
        grid on        
        xlabel space
        ylabel time
        figure(2)
        subplot(length(SESS),length(TMS),c)
        plot(LI(:,nTMS,nSESS),1:TrialDuration);        
        set(gca,'ytick',[0 round(TrialDuration/2) TrialDuration],'yDir','reverse');        
        set(gca,'xlim',[xmini xmaxi])
        set(gca,'ylim',[0 TrialDuration])
        grid on
        box off        
        xlabel('AsymmIndex')        
        drawnow
        title(cell2str(selection),'interpreter','none');     
    end
end
% 
% figure(1)
% supertitle(['Subject: ' mat2str(nSUB)],1);
% print('-dpng',[p.Base 'MirrorEffect_plot/SpaceTimePlot_JoseTMS_sub_' mat2str(nSUB)])
% print('-depsc',[p.Base 'MirrorEffect_plot/SpaceTimePlot_JoseTMS_sub_' mat2str(nSUB)])
% figure(2)
% supertitle(['Subject: ' mat2str(nSUB)],1);
% print('-dpng',[p.Base 'MirrorEffect_plot/AsymmIndex_JoseTMS_sub_' mat2str(nSUB)])
% print('-depsc',[p.Base 'MirrorEffect_plot/AsymmIndex_JoseTMS_sub_' mat2str(nSUB)])
% close(1)
% close(2)
