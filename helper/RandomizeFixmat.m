%randomize fixations of all fixations within a category, 
%so that we have an estimation of the fixation-feature correlations in a
%random observer


for nR = 1:100;
    fixmat = GetFixmat(2);
    display(nR)
for cat = 1:4
   i  = find(fixmat.condition == cat & fixmat.fix > 1);
   ir = randsample(i,length(i));
   
   fixmat.x(i)     = fixmat.x(ir); 
   fixmat.y(i)     = fixmat.y(ir);
   fixmat.start(i) = fixmat.start(ir);
   fixmat.trial(i) = fixmat.trial(ir);
%    fixmat.fix(i)   = fixmat.fix(ir);
   
   save(['~/pi/EyeData/fixmat_baseline_randomized_' mat2str(nR)],'fixmat');
   
end   
end
