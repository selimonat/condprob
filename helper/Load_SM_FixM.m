function [SMAP,fixmap,s]=Load_SM_FixM(PD,ni);
%[SMAP,fixmap]=Load_SM_FixM(PD,ni);
%
%Loads for a given image NI, the Saliency map and fixation map. Saliency
%map is computed according to the Posterior distribution in PD. PD is a
%string of file name corresponding to a given PD. The size of the FIXMAP is
%adjusted to match that of the PD.
%
%
%Selim, 28-Aug-2008 18:27:19


s    = Saliency(PD,ni);
SMAP = reshape(uint8(Scale(s.data)*255),s.CurrentSize);
%
fixmat = GetFixMat(s.p.FixmatInd);
fixmap = fixmat2fixmap(fixmat,s.p.kernel,s.p.CropAmount,s.p.bf,'image',ni,'fix',2:1000);
