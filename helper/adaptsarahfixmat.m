%adapt sarah fixmat


%0/adapt the subject field
fixmat.subject = fixmat.SUBJECTINDEX+1;%we add one to have it starting from 1 instead of 0.
fixmat =rmfield(fixmat,'SUBJECTINDEX');

%0.5/ remove two subject image data, becoz they contain somehow too many
%fixations. donnow the reason for this... Importantly remove them from both
%mirroring conditions.
%to remove
r = (fixmat.subject == 5 & fixmat.image == 209 ) | (fixmat.subject == 26 & fixmat.image == 158) | (fixmat.subject == 40 & fixmat.image == 47);
tfix = length(fixmat.x);
f=fields(fixmat);
for nf = 1:length(f);
    if length(fixmat.(f{nf})) == tfix;
	        fixmat2.(f{nf}) = fixmat.(f{nf})(~r);
    else
	fixmat2.rect = fixmat.rect;
	end;
end
fixmat = fixmat2;



%1/mirror back mirrored fixations

i = fixmat.condition == 1;
fixmat.x(i) = fixmat.rect(4)-fixmat.x(i);



%2/create new indices for each image according to their
%condition
%indices 1:255 are for no mirror.
%and 256:510 for mirrored images.
%thus new condition indices will be like this
% % %      1    65   129   193   256   320   384   448
% % %     64   128   192   255   319   383   447   510

fixmat.image(fixmat.condition == 1) = fixmat.image(fixmat.condition == 1) + 255;


%DIVIDE FIXMAT into LEFT RIGHT fixations
%these are calle fixmat_sarah_adapted_[left, right].mat
i = fixmat.x < fixmat.rect(4)/2;
fixmat_left = SelectFix(fixmat,i);
fixmat_right = SelectFix(fixmat,~i);


