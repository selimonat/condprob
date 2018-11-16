function Synt_Runner(f);
%creates artificial fixmats in a loop
for nf = 1:length(f);
    [S]      = Saliency(f{nf});%takes PD as input
    %[fixmat] = SyntFixMat(S,25,20);        
    [fixmat] = SyntFixMat(S,1,10000);        
end
