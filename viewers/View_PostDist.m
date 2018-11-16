function View_PostDist(feat,fwhm)
%View_PostDist(feat)
%Plots in a subplot of Nx4 posterior probabilities of 4 category of
%stimuli. N is the number of features entered in the cell array of FEAT.
%The posterior distribution files which are in $PostDist/1D/, the ones which
%fits to the one given in FEAT are detected for 4 of the categories and
%plotted one after each other.
%
%Selim, 31-May-2007 16:11:14
%
base = '/mnt/sonat/project_Integration/PostDist/1D/';
%
tf = length(feat);
counter  = 0;
for nf = 1:tf
   %Get for a given feature 4 of the post.dist. files.
   f = dir([base '*' feat{nf} '_nCat*' mat2str(fwhm) '*']);
   f = {f.name}
   f{:}
   %   
   for ncat = 1:4
       counter = counter + 1;
       load([base f{ncat}]);
       %
       subplot(tf,4,counter);     
       %
       plot(res.A.MedianPDF,'--');
       hold on
       plot(res.A.MeanPDF,'-');
       plot(res.C.MedianPDF);
       hold off
       %
       if ncat == 1
           dummy = find(feat{nf} == '_',2);
           ylabel(feat{nf}(1:dummy(2)-1),'interpreter','none');
       end
       axis([1 20 0.02 0.25 ])
       %       
   end
end
supertitle(feat{nf}(dummy(2):end),1,'interpreter','none')




