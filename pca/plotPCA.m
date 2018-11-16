function [o]=plotPCA(v,nco);

s = sqrt(length(v)/3);
o =[];

for nc = nco       
    o = vertcat(o, reshape(v(:,end-nc+1),s,s*3) );    
end



