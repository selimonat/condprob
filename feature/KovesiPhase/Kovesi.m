%USED TO COMPUTE THE PHASE FEATURES FROM KOVESI. FEATURES ARE COMPUTED IN
%THE DEFAULT SETTINGS

p = GetParameters;

mkdir([p.Base 'FeatureMaps/LUM_PS_Kovesi'])
mkdir([p.Base 'FeatureMaps/LUM_PC_CORNER_Kovesi'])
mkdir([p.Base 'FeatureMaps/LUM_PC_EDGE_Kovesi'])

for x = 1:p.CondInd(end)
    %read image
    ff = Images2FeatMap([p.Base 'FeatureMaps/LUM/'],x);
    %phase symmetry compute + save
    f = phasesym(reshape(ff.data,ff.CurrentSize));
    save(sprintf([ p.Base 'FeatureMaps/LUM_PS_Kovesi/image_%03d.mat'],x),'f')
    %
    %
    %phase congruency compute + save
    [f dummy2] = phasecong2(reshape(ff.data,ff.CurrentSize));
    save(sprintf([ p.Base 'FeatureMaps/LUM_PC_EDGE_Kovesi/image_%03d.mat'],x),'f')
    %
    f = dummy2;
    save(sprintf([ p.Base 'FeatureMaps/LUM_PC_CORNER_Kovesi/image_%03d.mat'],x),'f')
    
end
