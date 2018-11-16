function patch = fixmat2patch(fixmat,im,patchsize);
%patch = fixmat2patch(fixmat,im,patchsize,varargin);
%
%IM is a 2D matrix representing the image where the patches must be
%collected. PATCHSIZE is the size of patches to be extracted. All the
%fixations in the FIXMAT are used. It is recommended that FIXMAT is
%filtered before-hand to contain only those fixations which belond to the
%image IM.
%
%varargin is fed directly to SelectFix to filter the fixmat.
%
%
%Selim, 08-Dec-2008 11:46:55

%
ps       = round(patchsize/2)-1;
patch.ps = patchsize;
%round the coordinates
fixmat.x = round(fixmat.x);
fixmat.y = round(fixmat.y);
%invalid fixation within the filtered fixmat;
invalid  = (fixmat.y + ps > fixmat.rect(2)) | ...
            (fixmat.y - ps <= fixmat.rect(1)) | ...
                (fixmat.x - ps <= fixmat.rect(3)) | ...
                    (fixmat.x + ps > fixmat.rect(4));
fixmat   = SelectFix(fixmat,~invalid);                
tfix     = length(fixmat.x);

%
for nfix = 1:tfix  
    if nfix == 1%init the storage
        display('init patch')
            patch.d = zeros(tfix,patchsize^2,'uint8');
    end        
    dummy  = im(fixmat.y(nfix)-ps:fixmat.y(nfix)+ps,fixmat.x(nfix)-ps:fixmat.x(nfix)+ps);
    patch.d(nfix,:) = dummy(:)';        
end