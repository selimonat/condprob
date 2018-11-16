 
fixmat.start = fix.start'
fixmat.end = fix.start'+fix.dur' 
fixmat.x = fix.x'
fixmat.y = fix.y'
fixmat.fix = fix.eventorder'
fixmat.subject = fix.sujeto' 
fixmat.image = zeros(1,length(fix.bmp_name))


names = unique(fix.bmp_name)

path = '/net/space/users/jose/Neglect/newanal/Stimuli/'
fixmat.image = zeros(length(fix.bmp_name),1);

for n_name = 1:length(names)
       
    i               = strcmp( fix.bmp_name,names{n_name});
    fixmat.image(i) = n_name;
    
   % movefile([path names{n_name} '.bmp'],[path sprintf('image_%02d.bmp',n_name)])    

end