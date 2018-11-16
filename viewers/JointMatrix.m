%MAKE A SUBPLOT OF THE CONTROL DISTRIBUTIONS FOR EACH OF THE FEATURES.

load ~/pi/tmp/SelectedFeatures.mat
%this order is better for the matrix view
foi_ordered = {foi{[6 7 8 9 11 12 13 14 15 1 2 3 4 5 10]}}';

[foi2 mat] = CombineFeatures(foi_ordered);
mat = {mat{:}}';
tfeat = sqrt(length(mat));
figure('position',[0 0 1200 1200])

tpair = length({mat{:}});
for nf = 1:tpair;
    %CORRECT TO TAKE THE TRANSPOSE OF THE FOR THE LOWER TRIANGLE!
    pd_file = FilterF('PostDist', ['2Dimen#' mat{nf}{1} '#' mat{nf}{2} '#'],'_Im_\\[1:192\\]');
    if isempty(pd_file{1})
        %if the output is empty it could be that the order of features in
        %the file is the switched version        
        pd_file = FilterF('PostDist', ['2Dimen#' mat{nf}{2} '#' mat{nf}{1} '#'],'_Im_\\[1:192\\]');        
        if length(pd_file) > 1;
            display('there is a problem. There must be a single file here');
            keyboard
        end
        display('checking... solved');
    end
    load([ '~/pi/PostDist/' pd_file{1}]);
    %now we have RES variable
    %
    h(nf) = subplot(tfeat,tfeat,nf);    
    set(h(nf),'ActivePositionProperty','Position');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%Get the Saliency Matrix p(fixation|feature);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    C = reshape(res.C.MeanPDF,repmat(res.nBin,1,res.nDimen)) ;   
    A = reshape(res.A.MeanPDF,repmat(res.nBin,1,res.nDimen)) ;   
    %The problem is that we have some times zeros in the C distributions
    %and this causes to have NaN in the JOINT.
    Saliency = A./C;
%    Saliency = C;
%     if sum(C == 0)
%         Saliency(C==0)= 0;
%     end
%    Saliency = Saliency./sum(Saliency(:));    
%    Saliency = reshape(Saliency,repmat(res.nBin,1,res.nDimen));
    %
%    Saliency = Vectorize(sum(Saliency,2))*sum(Saliency);
%    Saliency = Saliency./sum(Saliency(:));
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %imagesc(Saliency,[0 0.004]);
    imagesc(Saliency,[0.5 2]);
    %
    axis xy
    set(gca,'xticklabel',[],'yticklabel',[]);   
    %
    if rem(nf,tfeat) == 1
        ylabel(mat{nf}{1},'interpreter','none','fontsize',6,'rotation',0,'horizontalAlignment','right')
    end
    if nf > tpair-tfeat
        xlabel(mat{nf}{2},'interpreter','none','fontsize',6,'rotation',90,'horizontalAlignment','center')
    end
    axis square
    drawnow
    %
    p    = get(h(nf),'position');
    p(3) = p(3) + 0.01;
    p(4) = p(4) + 0.01;
    set(h(nf),'position',p);
    %
end
