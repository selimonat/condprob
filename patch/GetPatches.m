clear patch
%
ps         = 41;
fixmat_ori = GetFixMat(1);
%
p          = GetParameters;
conds      = {'N' 'F' 'U' 'P'};
%
patch.patchsize = ps;
for ncond = 1:4;
    %
    imgs   = p.CondInd(ncond,1):p.CondInd(ncond,2);
    fixmat = SelectFix(fixmat_ori,'image',imgs);
    patch.(conds{ncond}).d =[];
    %
    ti = length(fixmat.image);
    for i = unique(fixmat.image);
        ProgBar(i,ti);    
        %load the Ith Image
        im = Load_GrayImage(i);
        im = uint8(im);
        %Get the patches
        fixmat_ = SelectFix(fixmat,'image',i);
        patch_ = fixmat2patch(fixmat_,im,ps);
        %Append it 
        patch.(conds{ncond}).d = [patch.(conds{ncond}).d ;patch_.d ];
        patch.(conds{ncond})
    end
    %
end