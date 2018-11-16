function s = TestDKL2;

f = ListFiles('*.mat');
%
for nf = 1:255;   
     %
     display(nf)
     tic
     load(f{nf});
     toc
     %

 end