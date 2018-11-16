function UnAddNoise(feat)
%UnAddNoise(feat,varargin)
%this function undoes the effect of AddNoise. 
%
%Selim, 01-Oct-2008 18:19:56




base = ['/work2/FeatureMaps/'];
tf = length(feat)
for nf = 1:tf
	for ni = 1:10%255;
    %
	[nf ni]
	%keyboard
	file = sprintf([base feat{nf} '/image_%03d.mat'],ni );	
	load(file);
    %take the zero-padding out
	[f d]   = CropperCleaner(f,[]);
    %store the size
    s = size(f);
    %vectorize so that we can sort all
    f = f(:);
    %take log10 and sort the data, keep the indices
    [fl ind] = sort(log10(f));
    %apply the same index transformation to the data nonlogtenned
    f2  = f(ind);
    %take the derivative
    fd = diff(fl);
    %find the 10^3 in the sorted data
    dummy = abs(fd - 3 );
    smallest = find( dummy == min(dummy))+1%3 becoz we added a noise of 1/1000th.
    %smallest is the index of the pixel which was the smallest non-zero
    %element in the original featuremap before AddNoise shitted on it. And
    %+1 is there becoz diff shifts the indices by one
    %
    %here we put all to zero back.
figure(1)
plot(fd,'o-')
% hold on
% plot(smallest,3,'ro')
% hold off
    %
    f(f<f2(smallest)) = 0;
    %un-vectorize
    f = reshape(f,s);
    %pad it
	f = padarray(f,[d d]);
    %save the shit!
% 	save(file,'f');
pause
    end
end