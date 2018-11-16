function [folder]=Param2Folder(p)
%[folder]=Param2Folder(p)
%Creates a string specific to the parameters contained in P structure
%RELATED TO THE COMPUTATION OF BINEDGES. This string is usually used to
%create a folder/file name specific to the parameters. P array is usually
%returned by calling GetParameters.m.
%
%
%
%Selim, 31-May-2007 15:22:26
%Selim, 11-Sep-2007 18:17:21, added the ability to summarize long subject
%index string. Thus we are not anymore creating long file names with the
%long the subject indices.


folder = [];
f = fieldnames(p);
for nf = 1:length(f);
    %these are the fields of the parameter structure which DOES NOT
    %contribute to the parameter finger print
    if ~(strcmp(f{nf}, 'kernel') | strcmp(f{nf}, 'CondInd')  | strcmp(f{nf},'folder') ...
            | strcmp(f{nf},'ffcommand') | strcmp(f{nf},'Base') | strcmp(f{nf}, 'nBS') )
        
        
        if strcmp(f{nf},'weight')
            folder = [folder 'W_' p.(f{nf}) '_']; %mat2str transformation of a string is useless            
        elseif strcmp(f{nf},'CropAmount')
            folder = [folder  'CA_' mat2str(p.(f{nf})) '_'];
        elseif strcmp(f{nf},'start')
            folder = [folder  'S_' mat2str(p.(f{nf})) '_'];
        elseif strcmp(f{nf},'end')
            folder = [folder  'E_' mat2str(p.(f{nf})) '_'];
        elseif strcmp(f{nf},'fixs')
            folder = [folder  'FS_' mat2str(p.(f{nf})) '_'];
        elseif strcmp(f{nf},'fixe')
            folder = [folder  'FE_' mat2str(p.(f{nf})) '_'];
        elseif strcmp(f{nf},'subjects')
            folder = [folder  'S_' SummarizeVector(p.(f{nf})) '_'];
        elseif strcmp(f{nf},'FixmatInd')
            folder = [folder  'FI_' mat2str(p.(f{nf})) '_'];
        elseif strcmp(f{nf},'pooled')
            folder = [folder  'P_' mat2str(p.(f{nf})) '_'];
        elseif strcmp(f{nf},'factor')
            folder = [folder  'fac_' mat2str(p.(f{nf})) '_'];
        else
            folder = [folder f{nf} '_' mat2str(p.(f{nf})) '_'];
        end
        
        
    end
end

folder(end) = [];
