inP = '~/pi/FeatureMaps/LUM/';
outP = '~/pi/FeatureMaps/';
fn=dir('~/pi/FeatureMaps/LUM/*.mat');
%scale = 3*2.^(0:6);
ps     = [outP 'LUM_PS_WL_96_nSc4_multi1p4'];        
for n = 1:numel(fn)
    imgNr = num2str(str2num(fn(n).name(findstr(fn(n).name,'_')+1:findstr(fn(n).name,'.')-1)),'%03.f');
    img = load([inP fn(n).name]);
    img = img.f;
    %imagesc(img);
    %drawnow;
[phaseSym, orientation, totalEnergy] = phasesym(img, 4, 6, 96, sqrt(2));
    %[edgeStrength,cornerStrength, phaseSym]=phaseFeats(img);

%    for w = 1:numel(scale)
        %create the folder if they dont exist
%         corner = [outP 'LUM_PC_CORNER_WL_' num2str(scale(w))];
%         edge   = [outP 'LUM_PC_EDGE_WL_' num2str(scale(w))];
        
%         if exist(corner) == 0
%             mkdir(corner)            
%         end
%         if exist(edge) == 0
%             mkdir(edge)            
%         end
        if exist(ps) == 0
            mkdir(ps)            
        end
        %
        %Save the stuff
% %         f = cornerStrength(:,:,w);        
% %         eval(['save ' corner '/image_' imgNr  '.mat f;'])
% %         %
% %         f = edgeStrength(:,:,w);
% %         eval(['save ' edge '/image_' imgNr ' f;'])
% %         %
        f = phaseSym;
        eval(['save ' ps '/image_' imgNr ' f;'])
%    end
end

