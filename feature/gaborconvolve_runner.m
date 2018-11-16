tf = 6;
to = 6;
firstscale = 3;
p = GetParameters;
%
for i = 1:p.CondInd;
 	ProgBar(i,255);

	%extract the image
	ff = Images2FeatMap([p.Base 'FeatureMaps/LUM/'],i);
	im = reshape(ff.data,ff.CurrentSize);
	
	R = gaborconvolve(im,tf,to,firstscale,2,0.65,1.5,0);%default values of Mr.
	%Kovesi (except the number of scales which we choose to be 6 here)

% % for nf = 1:tf
% % 	Scala = firstscale*2.^(nf-1);
% % 	if i == 1
% % 		mkdir([p.Base 'FeatureMaps/GaborConvolve_Freq_' mat2str(Scala) '_Orient_All']);
% % 	end
% % 	%average across orientations
% % 	f = mean(abs(cat(3,R{nf,:})),3);
% % 	f = padarray(  CropperCleaner(f,p.CropAmount),[p.CropAmount p.CropAmount ]);
% % 	save(sprintf([p.Base 'FeatureMaps/GaborConvolve_Freq_' mat2str(Scala) '_Orient_All/image_%03d.mat'],i),'f');
% % 	
% % 	
% % 	for no = 1:to
% % 
% % 		if i == 1
% % 			mkdir([p.Base 'FeatureMaps/GaborConvolve_Freq_' mat2str(Scala) '_Orient_' mat2str(no)]);
% % 			mkdir([p.Base 'FeatureMaps/GaborConvolve_Freq_All_Orient_' mat2str(no)]);
% % 		end
% % 	
% % 		f = abs(R{nf,no});
% % 		f = padarray(  CropperCleaner(f,p.CropAmount),[p.CropAmount p.CropAmount ]);
% % 		save(sprintf([p.Base 'FeatureMaps/GaborConvolve_Freq_' mat2str(Scala) '_Orient_' mat2str(no) '/image_%03d.mat'],i),'f');
% % 		%Average across all frequencies
% % 		f = mean(abs(cat(3,R{:,no})),3);
% % 		f = padarray(  CropperCleaner(f,p.CropAmount),[p.CropAmount p.CropAmount ]);
% % 		save(sprintf([p.Base 'FeatureMaps/GaborConvolve_Freq_All_Orient_' mat2str(no) '/image_%03d.mat'],i),'f');
% % 
% % 
% % 	end
% % end
	if i == 1
		mkdir([p.Base 'FeatureMaps/GaborConvolve_Freq_All_Orient_All']);
	end

	%Average across frequencies and orientations
	f = mean(abs(cat(3,R{:})),3);
	f = padarray(  CropperCleaner(f,p.CropAmount),[p.CropAmount p.CropAmount ]);
	save(sprintf([p.Base 'FeatureMaps/GaborConvolve_Freq_All_Orient_All/image_%03d.mat'],i),'f');

end
