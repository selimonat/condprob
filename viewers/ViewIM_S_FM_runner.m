close all
cat = {'A' 'B' 'C'};
for nf = ListFiles('2Dimen*[1:192]*')
    im = [1:64;65:128;129:192]
    for ncat = 1:3
        ViewIM_S_FM([im(ncat,:)],nf{1})
        set(gcf,'position',[100 0 100 1200 ])
        exportfig(gcf,['~/pi/View_ST_SM_FIXM/' nf{1}(1:end-4) '_' cat{ncat} '.pdf'],'resolution',1200,'format','pdf');
    end    
    close all
end