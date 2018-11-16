function [out]=PDmat2PCA(PDmat)


tCat  = size(PDmat.A.mean,2);
tFeat = length(PDmat.feat_short);
%compute the saliency
data = (PDmat.A.mean(:,:,1:tFeat)./(PDmat.C.mean(:,:,1:tFeat)));
data_ori = data;

%NORMALIZE THE DATA VECTOR TO


%remove the redundant part
if PDmat.nDimen == 2
    %
    [y x] = ind2sub([tFeat tFeat],1:tFeat*tFeat);
    mask  = (y > x);
    data  = data(:,:,mask);
    out.mask = mask;
    %
elseif PDmat.nDimen == 3
    %
    [x y z] = ind2sub([tFeat tFeat tFeat ],1:tFeat^3);
    index   = [z;y;x]';
    mask    = (index(:,2) >= index(:,3)) & (index(:,1) >= index(:,2));
    data    = data(:,:,mask);    
    %
end

%reshape for ease:
%our aim is to built a 2 by 2 matrix (percentile,observation) out of 4
%dimensional (percentile, category, feature1, feature2 ) matrix.
s    = size(data);
data = reshape(data(:),[s(1) prod(s(2:end))]);

%remove the mean;
data = data - repmat( mean(data) , [size(data,1) ones(1,ndims(data)-1)] );


%PCA analysis
[out.V,out.D] = eig( cov(data'));
out.V         = (out.V);
out.D         = flipud(diag(out.D));

%compute loadings, the resulting out. P must be the same size as the
%data_ori, the first dimension being the only difference: Instead of
%percentiles we will have the PCA components.

for nCat = 1:tCat
    for nFeat = 1:tFeat.^PDmat.nDimen
    
            if PDmat.nDimen == 1
                [nCat nFeat]
                [x]     =  ind2sub(repmat(tFeat,PDmat.nDimen),nFeat)
%                 figure(1);plot(out.V);;figure(2);plot(squeeze(data_ori(:,
%                 nCat,x)));drawnow;
                out.P(:,nCat,x) = out.V'*squeeze(data_ori(:,nCat,x));
                
            elseif PDmat.nDimen == 2
                
                [x y]   =  ind2sub(repmat(tFeat,PDmat.nDimen),nFeat);
                out.P(:,nCat,y,x) = out.V'*squeeze(data_ori(:,nCat,y,x));        
                
            elseif PDmat.nDimen == 3
                
                [x y z] =  ind2sub(repmat(tFeat,PDmat.nDimen),nFeat);
                out.P(:,nCat,y,x,z) = out.V'*squeeze(data_ori(:,nCat,y,x,z));        
                
            end                        
            
    end
end



%find the eigenvalue where 95% of variance is explained
Thr    = 0.95;
out.ExpVar = cumsum(out.D)./sum(out.D);
[Lim_ori] = find((out.ExpVar - Thr) > 0,1);
if Lim_ori > 8
    Lim = 8;
else
    Lim = Lim_ori;
end
out.Lim = Lim
out.Thr = Thr;
%
%
%PLOT THE EIGENVALUES in A CUM WAY
figure(200);
plot(out.ExpVar,'ko-','markersize',15);%explained variance plot
xlabel eigenvectors
ylabel('Explained Variance')
axis square
title([ mat2str(Lim_ori) ' components explains 95 %'])
box off
%PLOT THE EIGENVECTORS with THE EIGENVALUE AT THE TITLE AND THE LOADINGS AS
%A BAR PLOT ON THE RIGHT HAND SIDE
figure(100)
set(gcf,'position',[0 0 1440 900])
c = 0;
for nC = 1:Lim
    c = c+1;
    figure(100)
    subplot(ceil(sqrt(Lim)),ceil(sqrt(Lim)),c)
    
    if PDmat.nDimen== 1
        plot(out.V(:,end-nC+1))
    elseif PDmat.nDimen== 2        
        imagesc(reshape(out.V(:,end-nC+1),repmat(PDmat.nBin,1,PDmat.nDimen)));
        axis xy        
    elseif PDmat.nDimen == 3        
        v = reshape(out.V(:,end-nC+1),repmat(PDmat.nBin,1,PDmat.nDimen))
        [x,y,z] = meshgrid(1:4);
        T = 10
        h = slice(x,y,z,v,linspace(1,4,T),linspace(1,4,T),linspace(1,4,T));
        alpha('color')
        set(h,'EdgeColor','none','FaceColor','interp','FaceAlpha','interp')
        alphamap('rampup')
        alphamap('increase',.05)        
    end
    title(['Eigenvector # ' mat2str(nC) ' : explains ' mat2str(round((out.D(nC)./sum(out.D(:)))*100)) '% '])
    %
end
supertitle([mat2str(Lim) ' Eigenvectors which explains at least ' mat2str(Thr) ' % of variance'],1)

