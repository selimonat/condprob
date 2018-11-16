function View_PostDist_1D(FM,varargin)
%View_PostDist_1D(FM,varargin)
%View_PostDist_1D(FM,equalaxis)
%
%FM is a cell array of PD filenames. The first dimension usually contains
%the features and the second dimension the categories.
%
%the following code can be used to create FM
%%load the features. Returns FOI
%load ~/pi/tmp/SelectedFeatures.mat%
%clear f
%for x = 1:length(foi);
%    ff     = FilterF('PostDist','1Dimen','"\[1:192\]"',['\#' foi{x} '\#']);
%    f{x,1} = ff{:};
%end
%
%Alternatively in case you would like to use PDmat data array to plot the
%posterior distributions PDmat2Plot1D can be used.
%
%Selim, 31-May-2007 16:11:14

base     = ['~/project_Integration/PostDist/'];
res      = [];
%
%FM = {FM{:}}';%verticalize the file name cell array
%

tCond = size(FM,2);
tFile = size(FM,1);
%
fpf   = 10;%maximum number of subplot rows per figure;
if tFile < fpf
    fpf = tFile;
end
%the rational behind the lines above is that each figure has a maximum
%number of rows of subplots. This restriction is here to avoid encombrement
%of subplots. However when the number of files given as input is smaller
%than the maximum number of rows allowed, this number is set to the number
%of entries in the input so that the space across the figure is optimally
%used.
%
counter = 0;
for nf = 1:tFile
%when we used all the available subplots within an figure we open a new
%figure
    if mod(counter,fpf*tCond) == 0;
        figure('position',[0 0 200*tCond 128*fpf ]);
        %In case FPF is 10 (maximum allowed) the figure will span the screen vertically
        counter  = 0;
    end

    for ncat = 1:tCond;
       %
       counter = counter + 1;
       load([base  FM{nf,ncat}]);
       %
       subplot(fpf,tCond,counter);     
       hold on
       plot(res.A.MeanPDF,'r-');
       %       plot( res.A.MedianPDF , 'r--' );
       plot(res.C.MeanPDF);
       hold off
       axis tight;
       %here we store the axis limits of each of the subplots so that later
       %we will adjust for a global optimal axis values for all of the subplots.
       al(counter,:) = [get(gca,'xlim') get(gca,'ylim')];
       %
        if ncat ~= inf            
            h = title(res.feature,'interpreter','none','FontSize',8);
        end
%        if nf == inf;
%            title(mat2str(p.CondInd(ncat,:)));
%        end
       %
       %       
       drawnow;
       grid on
   end
end

if ~isempty(varargin)
    if varargin{1} == 1
        SetAxis;%if required put all the axis limits to same value.
    end
end

%
%
    function SetAxis;                               
        %here we equalize all the axis. otherwise the differences are not
        %nicely visible.
        al = [ prctile(al(:,3),5) prctile(al(:,4),98) ];
        counter = 0;
        fcounter = 1;
        for nf = 1:tFile          
            if mod(counter,fpf*tCond) == 0;
                figure(fcounter);            
                counter  = 0;
                fcounter = fcounter + 1;
            end   

            for ncat = 1:tCond;               
               counter = counter +1;
               subplot(fpf,tCond,counter); 
               set(gca,'YLim',al);
           end
        end
    end
end