function FourBasicFeatures

%This function runs over all the rgb images we have and converts them into
%DKL space. It saves each separate channel information into different
%folders. This function creates the four basic folder within the
%Featuremaps directory.


p = GetParameters;
base = [p.Base 'FeatureMaps/'];

totalimage = p.CondInd(end);

feat = {'RG', 'YB', 'LUM', 'SAT'};%these must correspond to file names


for ni = 1:totalimage;
	display(sprintf(['saving image %02d'],ni));

	dummy = Load_RGBImage(ni);%laod the image.

	dkl = OS_RGB2DKL(dummy);%the double converion is done inside.

	dkl(:,:,4) = DKL2SAT(dkl);%compute the saturation map;

	for ch = 1:4
	
	if ch ~= 3
		im = dkl(:,:,ch);
		filename = [base feat{ch} '/' sprintf('image_%03d.mat',ni)]
		save( filename , 'im' );
	else
		
		im = double(rgb2gray(dummy))./255;
		filename = [base feat{ch} '/' sprintf('image_%03d.mat',ni)]
		save( filename , 'im' );
	end
	
	end

end


