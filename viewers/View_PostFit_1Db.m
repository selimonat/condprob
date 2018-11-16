%this is used to plot the results of View_PostFit_1D. Actually that
%function is a plotter function but it does not make nice plots in the case
%of pooled analysis so I use this bit of text to plot them nicer. iN FUTURE
%THEY MUST BE SOMEHOW MERGED. BBplot_1D is rather like a black board
%script, this one too but it is separate becoz it must be merged with
%View_PostFit_1D.
%
%
%F is the {feature,category} computed in BBplot1D.
label  = {'N' 'F' 'U' 'P'}
ranked = []
for nc = 1:4
    [ent dummy i ] = View_DeltaEntropy_1D({f2{:,nc}}');%F2 comes from BBplot1D
    ranked{nc}     = [{f2{i,nc}}'];
    %    figure(2);
    %    SaveFigure(['~/pi/matlab/condprob/latex/1D_Entropy_' label{nc} '_ordered'])
    %    close all
    %RANKED NOW CONTAINS ALL THE FEATURES RANKED WITHIN THEIR CATEGORY.
    %MAKE all the D's different in different CELL ARRAYS
    [D1{nc}] = View_PostFit_1D(ranked{nc},1);
    [D{nc} ] = View_PostFit_1D(ranked{nc},2);
    close all
end
%

%with D which is the output of the View_PostFit_1D file input variable
%ORDER = 2. PLots the result of the View_PostFit_1D in an alternative more
%friendly, sorted way.
for CAT  =1:4;
    %
    figure('position',[0 0 1600 500])
    tSub = size(D{CAT}.d,3);
    tFeat = size(D{CAT}.d,2);
    for x = 1:tSub
        subplot(1,tSub,x)
        plot(D{CAT}.d(1,:,x),1:tFeat,'o-','markersize',10)
        if x == 1
            set(gca,'ytick',1:tFeat,'yticklabel',[D{CAT}.feat{:}])
        else
            set(gca,'ytick',1:tFeat,'yticklabel',[])
        end
        grid on
        title(D{CAT}.head{x});
    end

    %with D1 which is the output of the View_PostFit_1D file input variable ORDER = 1.
    c = 0;
    for x = [1 2 4 5 6]
        c = c+1
        subplot(1,tSub,x)
        hold on
        plot(D1{CAT}.d(1,:,c),1:tFeat,'ro-','markersize',12)
    end
    supertitle(label{CAT},1)
    %SaveFigure(['~/pi/matlab/condprob/latex/1D_Stats_' label{CAT} '_ordered'])
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%THIS IS THE SAME AS ABOVE BUT ON POOLED DATA:
load ~/pi/tmp/SelectedFeatures.mat
%
clear f
for x = 1:length(foi);
    ff     = FilterF('PostDist','1Dimen','"\[1:192\]"',['\#' foi{x} '\#']);
    f{x,1} = ff{:};
end
[ent dummy i ] = View_DeltaEntropy_1D(f);
ranked = {f{i}}';
%
D1 = View_PostFit_1D(ranked,1);
D  = View_PostFit_1D(ranked,2);
%
label  = {'N' 'F' 'U' 'P'}
figure('position',[0 0 1600 500])
tSub = size(D.d,3);
tFeat = size(D.d,2);
for x = 1:tSub
    subplot(1,tSub,x)
    plot(D.d(1,:,x),1:tFeat,'o-','markersize',10)
    if x == 1
        set(gca,'ytick',1:tFeat,'yticklabel',[D.feat{:}])
    else
        set(gca,'ytick',1:tFeat,'yticklabel',[])
    end
    grid on
    title(D{CAT}.head{x});
end

%with D1 which is the output of the View_PostFit_1D file input variable ORDER = 1.
c = 0;
for x = [1 2 4 5 6]
    c = c+1
    subplot(1,tSub,x)
    hold on
    plot(D1.d(1,:,c),1:tFeat,'ro-','markersize',12)
end
supertitle(label,1)
SaveFigure(['~/pi/matlab/condprob/latex/1D_Stats_pooled'])
