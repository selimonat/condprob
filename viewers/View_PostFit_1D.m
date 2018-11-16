function [D]=View_PostFit_1D(FM,order);
% [D]=View_PostFit_1D(FM,order);
%
%
% FM is the PD files organized in a cell array. It can be in the shape of a
% matrix. e.g. {file,condition}. This function ...
%
%
% See also View_PostFit_1Db especially in the case of pool.


%base      = [p.Base 'PostFit/'];
tFiles    = size(FM,1);
tCond     = size(FM,2);
foi       = [];
D.d       = [];
D.d_ci    = [];
tParam    = [];
res       = [];
%
%Prepare the titles. These are the parameters we would like to plot.
GetHead;
%
GetResultsAsAMatrix;
PlotResults;
%
%1D_PostDist_SummaryFigure.png
%
    function PlotResults
        figure('position',[0 0 200*tFiles 1200])
        c = 0;
        for nparam = 1:tParam
            for nf = 1:tFiles
                %
                c = c+1;
                subplot(tParam,tFiles,c);
                bar(D.d(:,nf,nparam));                
                hold on
                errorbar( D.d(:,nf,nparam) , D.d_ci(:,nf,nparam) , 'ro' )
                axis([0 5 min(min(D.d(:,:,nparam))) max(max(D.d(:,:,nparam)))]);
                drawnow
                %Put the name of the feature.
                if nparam == 1
                    title(foi{nf},'interpreter','none','fontsize',6);
                end
                if mod(c-1,tFiles)+1 == 1
                    ylabel(D.head{nparam});
                end
            end
        end
    end
%
    function GetResultsAsAMatrix
        %        Place the results of statistical analysis for different images in
        %        a  matrix.

        for nf = 1:tFiles%Each file name is one feature. For a given feature
            %we will plot the value of different parameters for different
            %categories.
            ProgBar(nf,tFiles);
            data    = [];
            data_ci = [];
            for ncat = 1:tCond;%Accumulate data for different categories.
                alo = [ '~/pi/PostFit/' FM{nf,ncat}];
                dummy = load(alo);%$$$%^#@!#%$%^^$^#$^$#^@FAck
                res   = dummy.res;
                %
                if res.fit(order).A.MeanPDF.p == 0
                    res.fit(order).A.MeanPDF.p = 10^-10;
                end
                data = [data ; ...
                    [res.fit(order).A.MeanPDF.beta ; res.fit(order).A.MeanPDF.r ; log10(res.fit(order).A.MeanPDF.p) ; res.entropy.C.MeanPDF - res.entropy.A.MeanPDF]'];
                %
                data_ci = [ data_ci; [res.fit(order).A.MeanPDF.beta_ci; zeros(3,1) ]'];
            end
            D.d         = [D.d ; data];
            D.d_ci      = [D.d_ci ; data_ci];
            D.feat{nf}  = res.feature;
            foi{nf}     = res.feature;
        end
        %Reorganize the matrix
        tParam = size(D.d,2);
        D.d    = reshape(D.d(:),tCond,tFiles,tParam);
        D.d_ci = reshape(D.d_ci(:),tCond,tFiles,tParam);
        %D is organized as (feature,category,parameter);
    end

    function GetHead
        last = {'r^2','log_{10}(p)','H_{max}-H'};
        for no = 0:order+length(last);
            if no <= order
                D.head{no+1} = ['\beta_{' mat2str(no) '}'];
            else
                D.head{no+1} = last{no-order};
            end
        end
    end
end