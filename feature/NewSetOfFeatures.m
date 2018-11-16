function NewSetOfFeatures
%This function creates the featuremaps produced by fastradial, harris,
%canny functions.
p= GetParameters;
savefolder = [p.Base 'FeatureMaps/'];
p = GetParameters;
% % mkdir([p.Base 'FeatureMaps/fastradial_1_75_2/']);
% % mkdir([p.Base 'FeatureMaps/fastradial_10_100_3/']);
% % mkdir([p.Base 'FeatureMaps/fastradial_10_100_2/']);
mkdir([p.Base 'FeatureMaps/harris_45/']);
mkdir([p.Base 'FeatureMaps/harris_50/']);
mkdir([p.Base 'FeatureMaps/harris_55/']);
% mkdir([p.Base 'FeatureMaps/canny_3_EdgePower/']);
% mkdir([p.Base 'FeatureMaps/canny_3_Orientation/']);

for II =1:255
    
    ProgBar(II,p.CondInd(end));
	%extract the image
	ff = Images2FeatMap([p.Base 'FeatureMaps/LUM/'],II);
	im = reshape(ff.data,ff.CurrentSize);
% % % 	%compute the feature
% % % 	f = abs(fastradial(im, [1:75],2));%for Anke,there is basically a factor
% % % 	%of 0.6 between Jose's and Anke's recording parameters
% % %     %f = abs(fastradial(im, [1:75*0.6],3));
% % %  	f = padarray(  CropperCleaner(f,p.CropAmount),[p.CropAmount p.CropAmount ]);
% % %  	save(sprintf([p.Base 'FeatureMaps/fastradial_1_75_2/image_%03d.mat'],II),'f')
% % %     
% % %     %compute the feature
% % % 	f = abs(fastradial(im, [10:5:100],2));%for Anke,there is basically a factor
% % % 	%of 0.6 between Jose's and Anke's recording parameters
% % %     %f = abs(fastradial(im, [1:75*0.6],3));
% % %  	f = padarray(  CropperCleaner(f,p.CropAmount),[p.CropAmount p.CropAmount ]);
% % %  	save(sprintf([p.Base 'FeatureMaps/fastradial_10_100_2/image_%03d.mat'],II),'f')
% % %     
% % %     %compute the feature
% % % 	f = abs(fastradial(im, [10:5:100],3));%for Anke,there is basically a factor
% % % 	%of 0.6 between Jose's and Anke's recording parameters
% % %     %f = abs(fastradial(im, [1:75*0.6],3));
% % %  	f = padarray(  CropperCleaner(f,p.CropAmount),[p.CropAmount p.CropAmount ]);
% % %  	save(sprintf([p.Base 'FeatureMaps/fastradial_10_100_3/image_%03d.mat'],II),'f')
    
% % % 	%compute the feature
	f = harris(im,45);%Anke
    %f = harris(im,5*0.6);
	f = padarray(  CropperCleaner(f,p.CropAmount),[p.CropAmount p.CropAmount ]);
	save(sprintf([p.Base  'FeatureMaps/harris_45/image_%03d.mat'],II),'f')
% % % 	%
	f = harris(im,50);%anke
    %f = harris(im,10*0.6);
	f = padarray(  CropperCleaner(f,p.CropAmount),[p.CropAmount p.CropAmount ]);
	save(sprintf([p.Base 'FeatureMaps/harris_50/image_%03d.mat'],II),'f')
	%
    f = harris(im,55);%anke
	%f = harris(im,3*0.6);
	f = padarray(  CropperCleaner(f,p.CropAmount),[p.CropAmount p.CropAmount ]);
	save(sprintf([p.Base 'FeatureMaps/harris_55/image_%03d.mat'],II),'f')
% 	%
% 	[R a] = canny(im, 3);%anke
%     %[R a] = canny(im, 2);%3*0.6 doesnt work becoz it needs integer values
% 	f = padarray(  CropperCleaner(R,p.CropAmount),[p.CropAmount p.CropAmount ]);
% 	save(sprintf([p.Base 'FeatureMaps/canny_3_EdgePower/image_%03d.mat'],II),'f');
% 	%save also the orientation map but first mask it with orientation
% 	%strength
% 	f = a.*Scale(R);
% 	f = padarray(  CropperCleaner(f,p.CropAmount),[p.CropAmount p.CropAmount ]);
% 	save(sprintf([p.Base 'FeatureMaps/canny_3_Orientation/image_%03d.mat'],II),'f');
% 

end
