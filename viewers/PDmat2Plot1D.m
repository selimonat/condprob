function PDmat2Plot1D(pd,AXIS,varargin)
%
%
%PDmat is output of Feat2PDMat. Axis regulates how to render y-axis,
%whether it should be same or idiosyncratic for each panel.
%
%Use View_PostDist_1D to plot the data of a given set of PD files. That
%function accepts PD file names directly.
%
%Selim, 31-May-2007 16:11:14
%Selim, 04-Mar-2009 23:34:58, adapted to PDmat advent




tCat  = size(pd.A.mean,2);%determines the number of columns in the subplot
tFeat = length(pd.feat_short);
tBin  = size(pd.A.mean,1);
ax    =[];%Y axis variable
Color     = {'r','k','y','g','c','b','m','r','k','y','g','c','b','m'};%colors to be used for different categories
%
fpf   = 10;%maximum number of subplot rows per figure;
if tFeat < fpf
    fpf = tFeat;
end
%the rational behind the lines above is that each figure has a maximum
%number of rows of subplots. This restriction is here to avoid encombrement
%of subplots. However when the number of files given as input is smaller
%than the maximum number of rows allowed, this number is set to the number
%of entries in the input so that the space across the figure is optimally
%used.
%
%set the number of columns in the figure
tCol = 2;
%usefull for axis setting 
%x-axis:
X=linspace(0,100,tBin);
%
counter = 0;
for nf = 1:tFeat
    %when we used all the available subplots within an figure we open a new
    %figure
    if mod(counter,fpf*tCol) == 0;
        width = 200*tCol;
        figure('position',[0 0 width 128*fpf ]);
        %In case FPF is 10 (maximum allowed) the figure will span the screen vertically
        counter  = 0;
    end
    counter = counter + 1;
    for ncat = 1:tCat;
        %        
        %load([base  FM{nf,ncat}]);
        A = squeeze(pd.A.mean(:,ncat,nf));
        C = squeeze(pd.C.mean(:,ncat,nf));
        %
        subplot(fpf,tCol,counter);
        hold on
        %
        plot(X,A,'o-','color',Color{ncat},'linewidth',1);
        plot(X,C,'b','linewidth',1);      
        SetAxis
        %
        plot([1 1 ],[1/tBin-0.05 1/tBin+0.05],'linewidth',2)
        plot([99.5 99.5 ],[1/tBin-0.05 1/tBin+0.05],'linewidth',2)
        hold off        
        axis off
        grid on
        %
        if ncat ~= inf
            h = title(pd.feat_short{nf},'interpreter','none','FontSize',12);
        end
        drawnow;        
    end
end


    function SetAxis
        if AXIS == 1
            %All axes will have the same scale on Y
            if ncat == 1
                %max and min values/
                ax = [ min(pd.A.mean(:)) max(pd.A.mean(:)) ];
            end
            set(gca,'ylim',ax)         
        else%Different scales are allowed buy in case there are more than 1 
            %categories we plots those with the same scale
            if tCat > 1
                if ncat == 1
                    %max and min values of all conditions for a given
                    %feature
                    ax = [ min(min(pd.A.mean(:,:,nf))) max(max(pd.A.mean(:,:,nf))) ];
                end
                set(gca,'ylim',ax);
            else                
                axis tight
            end
        end
    end
end
