function M = View_DeltaEntropy_2D(feat);
%
%
M          = [];
FileMatrix = [];
tFeat      = length(feat);
tCond      = size(p.CondInd,1);
%
GetFileMatrix;
%
GetData;
%
PlotIt;
%

    function PlotIt;
        for nc = 1:tCond
            figure(nc);
            dummy = M{nc};
            %dummy(1:tFeat+1:tFeat^2) = NaN;%find the diagonal entries.
            imagesc(dummy);
            drawnow
            title( [ 'Condition: ' mat2str(nc) ]);
            set(gca,'ytick',1:10,'xtick',1:10,'yticklabel', {feat{:}},'xticklabel', {feat{:}},'fontsize',6)
            xticklabel_rotate([],90,[],'interpreter','none');
            axis image
        end
        %this is the average
        delta_mean = reshape(Vectorize(cell2mat(M)),tFeat,tFeat,tCond);
        delta_mean = mean(delta_mean,3);
        %delta_mean(1:tFeat+1:tFeat^2) = NaN;
        figure(nc+1);
        imagesc(delta_mean);
        set(gca,'ytick',1:10,'xtick',1:10,'yticklabel', {feat{:}},'xticklabel', {feat{:}},'fontsize',6)
        xticklabel_rotate([],90,[],'interpreter','none');
        axis image
    end


    function GetData;
        for nc = 1:tCond;
            display([mat2str(nc/tCond*100,2) ' % completed.']);
            for nf1 = 1:tFeat;
                for nf2 = 1:tFeat;
                    load([p.Base '/PostFit/' FileMatrix{nc}{nf1,nf2}])
                    M{nc}(nf1,nf2) = res.entropy.C.MeanPDF - res.entropy.A.MeanPDF;
                end
            end
        end
    end



    function GetFileMatrix_2D
        for nc = 1:tCond;
            for nf1 = 1:tFeat;
                for nf2 = 1:tFeat;
                    FileMatrix{nc}{nf1,nf2} = ['2Dimen_' ...
                        feat{nf1} '_Im_' SummarizeVector(p.CondInd(nc,1):p.CondInd(nc,2)) ...
                        '+' ...
                        feat{nf2} '_Im_' SummarizeVector(p.CondInd(nc,1):p.CondInd(nc,2)) ...
                        '_nBS_' mat2str(p.nBS) '_' p.folder];
                end
            end
        end
    end
end
