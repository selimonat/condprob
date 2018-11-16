
load ~/pi/EyeData/clickmat.mat;
fixmat  = SelectFix(clickmat);
%
p   	   = GetParameters('FWHM',90,'CondInd',[ 1 192]);
folder     = [p.Base 'FeatureMaps/ClickMap_FWHM_' mat2str(p.FWHM)];
%
mkdir(folder);
for x = 1:p.CondInd(end);    
    ProgBar(x,p.CondInd(end));
    f        = fixmat2fixmap(fixmat , p.kernel , 0 , 1 ,'ww','image',x);
    filename = sprintf('image_%03d.mat',x);
    save([ folder '/' filename],'f');    
end
