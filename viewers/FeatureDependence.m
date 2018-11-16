
load ~/pi/tmp/OrderedFeatures.mat
foi2  = CombineFeatures(foi);
tfeat = sqrt(length(foi2));
%

clear Ent;
for nf = 1:length(foi2);
    
    pd_file = ListFiles(['~/pi/PostDist/2Dimen#' foi2{nf}{1} '#' foi2{nf}{2} '#_Im_[1:192]*']);

    load(['~/pi/PostDist/' pd_file{1}]);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%Get the Saliency Matrix p(fixation|feature);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %we add epsilon so that the entropy measurement doesnt give us NaNs
    C = res.C.MeanPDF+rand(res.nBin.^res.nDimen,1)*10^-19 ;
    A = res.A.MeanPDF+rand(res.nBin.^res.nDimen,1)*10^-19;
    %The problem is that we have some times zeros in the C distributions
    %and this causes to have NaN in the JOINT.
    Saliency = A./C;
    if sum(C == 0)
        Saliency(C==0)= 0;
    end
    Saliency= Saliency./sum(Saliency(:));    
    Saliency= reshape(Saliency,repmat(res.nBin,1,res.nDimen));
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Ent.measured(nf) = -(Saliency(:)'*log2(Saliency(:)));
    Ent.A(nf)   = -(A(:)'*log2(A(:)));
    Ent.C(nf)   = -(C(:)'*log2(C(:)));
    %
    marj1 = sum(Saliency,2);marj2 = sum(Saliency);
    indep = marj1(:)*marj2(:)';
    %
    Ent.hypothetical(nf) = -(indep(:)'*log2(indep(:)));
    
end

Ent.hypothetical = reshape(Ent.hypothetical,tfeat,tfeat);
Ent.measured     = reshape(Ent.measured,tfeat,tfeat);
Ent.A= reshape(Ent.A,tfeat,tfeat);
Ent.C= reshape(Ent.C,tfeat,tfeat);
imagesc(Ent.measured)