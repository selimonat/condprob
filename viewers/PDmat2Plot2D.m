function PDmat2Plot2D(PDmat,what,feat_ind,varargin)
%PDmat2Plot2D(PDmat,what,featind,varargin)
%
%   Make a big square subplot of 2D probability distributions. What is
%   going to be plotted is determined by WHAT. If WHAT is equal to 1 the
%   control distributions are plotted. If equal to 2, A is plotted. With 3 A./C is
%   plotted.
%   FEATIND is the indices of the features to be displayed.
%
%   Keep in mind that in this case, the ratio may not be
%   determined because of zero entries in the denominator.
%
%   3 different ways of controling the colormap. By default, when VARARGIN
%   is not defined all subplots do have a common colormap. Alternatively
%   VARARGIN can be a scalar to adjust for the color clipping. It is then a
%   multiplicatif coefficient determining the color limits in terms of std
%   across the mean. Specially if equal to zero max and min values are
%   used. If present but empty than each subplot has its own colormap.
%
%Selim, 11-Feb-2009 10:44:16


%

tFile = sqrt(length({PDmat.feat{:}}));%number of all features
tfeat = length(feat_ind);%number of features to be plotted
dummy = [];
u = [];
d = [];
u1d =[];
d1d = [];
thr = [];
fontsize = 12;
%plot for each condition
%
tCond = length(PDmat.Cond);
for nCond = 1:tCond
    TobePlotted;
end

    function TobePlotted
        %%WHAT TO PLOT: The aim here is to build a variable which will be plotted
        %%in the next part by the function PlotIt.
        
        %first make the zero values really zero
        PDmat.C.mean (PDmat.C.mean == 10^-20) = 0;
        PDmat.A.mean (PDmat.A.mean == 10^-20) = 0;
        nBin = PDmat.nBin;
        %
        if what == 1
            display('plotting Control Distributions')
            dummy = squeeze(PDmat.C.mean(:,nCond,:,:));%gather the data
            CMap;
            PlotIt;
            supertitle(['Control Distributions: Condition ' mat2str(nCond)] ,1)
        elseif what == 2
            display('plotting Control Distributions')
            dummy = squeeze(PDmat.A.mean(:,nCond,:,:));%gather the data
            CMap;
            PlotIt;
            supertitle(['Actual Distributions: Condition ' mat2str(nCond)], 1)
        elseif what == 3
            display('plotting Actual./Control')
            dummy = squeeze(PDmat.A.mean(:,nCond,:,:)./(PDmat.C.mean(:,nCond,:,:)));
            CMap;
            PlotIt;
            supertitle(['Saliency: Condition ' mat2str(nCond)] ,1)
        end
        
        function CMap
            %DEFINE THRESHOLD FOR COLORMAP. This will be a common Threshold
            %for all the figures and subplots...
            if ~isempty(varargin)%if VARARGIN is given that overwrite the default value.
                thr = varargin{1};
            else%if there is no VARARGIN.
                thr = 1.1;
            end
            %
            if ~isempty(thr)
                if thr ~= 0
                    %colorbar limits
                    u = nanmean(dummy(:)) + nanstd(dummy(:))*thr;
                    d = nanmean(dummy(:)) - nanstd(dummy(:))*thr;
                elseif thr == 0
                    u = max(dummy(:));
                    d = min(dummy(:));
                end
                d = max(d,0);%if D is smaller than 0 than better to have zero as these are probabilities
                
            end
            
            
            %DETECT THE Y-AXIS SPAN for the DIAGONAL PLOTS
            if what ~= 3
                mp  = 1/PDmat.nBin;%middlepoint
                u1d = mp*3;
                d1d = 0;
            else
                u1d = 2;
                d1d = 0;
            end
            
            
        end
        
        function PlotIt
            %plot the joint map
            figure('position',[1051 0 1680 1200])
            %
            [suby,subx,wi,he] = SubPlotCoor(tfeat,tfeat);
            %feature indices
            yy = repmat(feat_ind',1,tfeat);
            xx = repmat(feat_ind,tfeat,1);
            %subplot indices
            XX = repmat(1:length(feat_ind),tfeat,1);
            YY = repmat((1:length(feat_ind))',1,tfeat);
            
            for nf = 1:tfeat.^2
                
                if yy(nf) <= xx(nf)%plot only the upper half
                    %Indices of features that are required to be plotted
                    y = yy(nf);
                    x = xx(nf);
                    %%indices of the subplots that are going to be drawn
                    Y = YY(nf);
                    X = XX(nf);
                    h(nf) = subplot('Position',[subx(X) suby(Y)  wi he ] );
                    %
                    %
                    dummy2 = reshape(dummy(:,y,x),repmat(PDmat.nBin,1,PDmat.nDimen));
                    %either plot a curve or draw an image. PLOT at diagonal
                    %positions
                    if y ~= x
                        if ~isempty(thr)
                            imagesc( dummy2 , [d u] );
                        else
                            imagesc(dummy2);
                        end
                        %DRAW DOTS FOR ENTRIES WHICH ARE EQUAL TO ZERO
                        hold on;
                        [Y X] = find(dummy2 == 0);
                        plot(X,Y,'.w');
                        colormap(hot);
                        %
                        %contour(dummy2,'k');%contourlines
                    else
                        plot(diag(dummy2));
                        box off
                        axis([1 PDmat.nBin d1d u1d])
                        set(gca,'xtick',[PDmat.nBin/2+0.5],'ytick',u1d/2)
                        grid on
                    end
                    %
                    Embellish;
                end
            end
            function Embellish
                axis xy
                set(gca,'xticklabel',[],'yticklabel',[]);
                
                %at the top write the feature index
                if  y == 1
                    title(mat2str(x),'interpreter','none','fontsize',fontsize,'rotation',0,'horizontalAlignment','center')
                end
                
                if  y == x
                    xlabel(PDmat.feat{1,y,x}{2},'interpreter','none','fontsize',fontsize,'rotation',0,'horizontalAlignment','center')
                end
                
                if (x == tfeat) & (y ~= x)
                    ylabel(mat2str(y));
                end
                
                axis square
                drawnow
                [d u]
                %
            end
        end
    end
end