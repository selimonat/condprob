fixmat = GetFixMat(2);%baseline fixmat
half = round(max(fixmat.x))/2
%
fixmat_right = SelectFix(fixmat,fixmat.x>=half);
fixmat_left  = SelectFix(fixmat,fixmat.x<half);

fixmat = fixmat_right;
save ~/pi/EyeData/fixmat_baseline_right fixmat

fixmat = fixmat_left;
save ~/pi/EyeData/fixmat_baseline_left fixmat