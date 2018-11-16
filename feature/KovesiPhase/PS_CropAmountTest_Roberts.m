outP = '~/pi/Test_PS/'
scale = 3*2.^(0:6);

for n = 1

    img = rand(960,1280);

    [edgeStrength,cornerStrength, phaseSym]=phaseFeats(img);

    for w = 1:numel(scale)
        %create the folder if they dont exist
        corner = ['LUM_PC_CORNER_WL_' mat2str(scale(w)) '.mat'];
        edge   = ['LUM_PC_EDGE_WL_' mat2str(scale(w)) '.mat'];
        ps     = ['LUM_PS_WL_' mat2str(scale(w)) '.mat'];        

        %
        %Save the stuff
        f = cornerStrength(:,:,w);        
        save(['~/pi/Test_PS/' corner],'f');
        %
        f = edgeStrength(:,:,w);
        save(['~/pi/Test_PS/' edge],'f');
%         %
        f = phaseSym(:,:,w);
        save(['~/pi/Test_PS/' ps],'f');
    end
end