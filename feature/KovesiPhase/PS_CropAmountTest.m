mkdir ~/pi/Test_PS/
for x = 1

ff  = rand(960,1280);
f   = phasesym(ff);
save('~/pi/Test_PS/LUM_PS_Kovesi.mat','f');


end
