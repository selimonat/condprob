function [edgeStrength,cornerStrength, phaseSym] = phaseFeats(img)
for scales = 0:6
    [edgeStrength(:,:,scales+1) cornerStrength(:,:,scales+1)] = ...
        phasecong2(img, 1, 6, 3*(2^scales));
    [phaseSym(:,:,scales+1), orientation, totalEnergy] = phasesym(img, 1, 6, 3*(2^scales));
end
