function [fark]=MirrorEffect(FixmatInd,varargin)
%[fark]=MirrorEffect(FixmatInd,varargin)
%
%%Creates two fixations maps (1) from normal images and (2) from mirrored
%%images. Corrects (2) (line 29, FLIPLR) and measures the difference. Computes also bootstrap
%%CI.
%
%FIXMAT : Sarah's fixmat
%VARARGIN : different ways of sorting the fixmat. It is a cell array. See
%example below.
%
%
%Example:
%fark_ga = MirrorEffect(fixmat,{ {'fix' 1 } {'fix' 2} {'fix' 3} {'fix' 4:20}});


p           = GetParameters;
fixmat      = GetFixMat(FixmatInd);
WritePath   = [p.Base 'MirrorEffect/' mfilename '_FI' mat2str(FixmatInd) '_' cell2str(varargin{:},[],[]) '.mat'];

if ~exist(WritePath,'file')%if it s not already computed, do it.
    
    p      = GetParameters;
    tBS    = 100;%number of bootstraps
    clear fark
    fark.d = varargin{1};
    tPart  = length(varargin{1});
    %
    for nPart = 1:tPart
        
        f0 = ...
            fixmat2fixmap(fixmat,p.kernel,0,2,'WWW','condition',0,varargin{1}{nPart}{:});
        %%FLIPLR is for the correction
        f1 = ...
            fliplr(fixmat2fixmap(fixmat,p.kernel,0,2,'WWW','condition',1,varargin{1}{nPart}{:}));
        %%VERTICAL AND HORIZONTAL DIFFERENCES
        fark.h(:,nPart) = mean(f0-f1);
        fark.v(:,nPart) = mean(f0-f1,2);
        
        for nBS = 1:tBS%Enter the bootstaping cycle.
            ProgBar(nBS+tBS*(nPart-1),tBS*tPart);
            %
            [fixmat2] = fixmatResample(fixmat);
            %
            f0 = ...
                fixmat2fixmap(fixmat2,p.kernel,0,2,'WWW','condition',0,varargin{1}{nPart}{:});
            f1 =...
                fliplr(fixmat2fixmap(fixmat2,p.kernel,0,2,'WWW','condition',1,varargin{1}{nPart}{:}));
            %
            fark.bs.h(:,nPart,nBS) = mean(f0-f1);
            fark.bs.v(:,nPart,nBS) = mean(f0-f1,2);
            
        end
        fark.bs.h_ci95 = prctile(fark.bs.h,[5 95],3);
        fark.bs.h_ci99 = prctile(fark.bs.h,[1 99],3);
        fark.bs.v_ci95 = prctile(fark.bs.v,[5 95],3);
        fark.bs.v_ci99 = prctile(fark.bs.v,[1 99],3);
        
    end
    save(WritePath,'fark');
else%load from the disk.
    a = load(WritePath);
    dummy = fieldnames(a);
    fark = a.(dummy{1});
end