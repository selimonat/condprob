function s = TestDKL;

f = ListFiles('*.mat');
%
for nf = 1:255;   
     %
     display(nf)
     load(f{nf});
     %
     
     s.mini.RG(nf) = min(Vectorize(DKL(:,:,1)));
     s.mini.YB(nf) = min(Vectorize(DKL(:,:,2)))
     s.mini.ML(nf) = min(Vectorize(DKL(:,:,3)));     
     
     s.maxi.RG(nf) = max(Vectorize(DKL(:,:,1)));
     s.maxi.YB(nf) = max(Vectorize(DKL(:,:,2)))
     s.maxi.ML(nf) = max(Vectorize(DKL(:,:,3)));     
     s.maxi.YB(nf)
     s.mini.YB(nf)
     keyboard
 end