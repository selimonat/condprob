
%separate fixations into slow and fast for each of the features
feat = f;
for x = 1:4%run over conditions    
    fixmat2 = SelectFix(fixmat,'condition',x);    
    dummy   = fixmat2.end(:) - fixmat2.start(:);
    med(x)  = median(dummy);    
    for nf = 1:length(feat);
    fast.(feat{nf})(x) = nanmean(fixmat2.(feat{nf})( dummy <  med(x) ));
    slow.(feat{nf})(x) = nanmean(fixmat2.(feat{nf})( dummy >= med(x) ));
    end    
end


%computes and plots p(duration|feature value);
%
%
for nf = 1:length(feat)    
    for x = 1:4    
        fixmat2 = SelectFix(fixmat,'condition',x); 
        figure(x)
        hold off
        %
        tbin = 50;
        C{2} = linspace(10,500,tbin);
        maxi = prctile(fixmat2.(feat{nf}),90);
        mini = prctile(fixmat2.(feat{nf}),20);
        C{1} = linspace(mini,maxi,tbin);
        %
        [n c]=hist3([fixmat2.(feat{nf})' double((fixmat2.end - fixmat2.start)')],C);
%       average on the x-axis        
        %
        n = n./repmat(sum(n),tbin,1);
        
        imagesc(c{2},c{1},log10(n));
        axis xy
        hold on
        %
        plot( c{2} , (c{1}*n)./max(c{1}*n)*maxi,'k');
%        set(gca,'xscale','log','yscale','log')
        title(feat{nf},'interpreter','none');
        drawnow        
    end
    pause    
end
