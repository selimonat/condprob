function [FileMatrix]=GetPlotMatrixLabel(feat,p)
%[FileMatrix]=GetPlotMatrixLabel(feat,p)
%
%
%This function takes a feature name and a parameter array to create a cell
%array of posterior distribution file names organized as
%{feature, condition}. The result will be used to plot the posterior
%distributions. The posterior distributions which are stored in FILEMATRIX
%are the ones which are computed using the parameter P.
%
%THIS FUNCTION IS OBSOLETE! THE SAME FUNCTIONALITY CAN BE OBTAINED BY USING
%LISTFILES OR FILTERF FUNCTIONS
%
%
%Selim, 11-Sep-2007 13:16:28

for nf = 1:length(feat);
    for nc = 1:size(p.CondInd,1)   
FileMatrix{nf,nc} = ['1Dimen#' feat{nf} '#_Im_' SummarizeVector(p.CondInd(nc,1):p.CondInd(nc,2)) '+nBS_' mat2str(p.nBS) '_' p.folder];
    end
end
