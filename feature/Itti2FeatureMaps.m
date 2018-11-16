function Itti2FeatureMaps(salMaps);
%Itti2FeatureMaps(salmaps);
%Saves the Itti saliency maps as feature maps. salmaps is the output of
%batchSaliency function from Itti's toolbox.
tf=length(salMaps);
for nf = 1:tf    
    f = ...
	imresize(salMaps(nf).data,[960 1280],'bilinear');
	%use of bilinear rather than bicubic. we dont want negative 
	%saliency values.
    ProgBar(nf,tf);    
    filename = sprintf('~/pi/FeatureMaps/IttiSalMaps/image_%03d.mat',nf);
    save(filename,'f');    
end
