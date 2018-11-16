function [file]=FilterF(Folder,varargin)
%[file]=FilterF(Folder,varargin)
%
%This function filters the files in FOLDER. Uses find and grep system
%functions. VARARGIN is fed to grep and each entry is used to filter the
%resulting find output. Actually this is not much more different 
%than ListFiles :-). The main difference being that it works recursively.
%As the main filtering is done on the terminal, care must taken that
%varargin is specified accordingly.
%
%EXAMPLE USAGE:
%FilterF('PostDist', 'LUM_C_Radius_45') would return all the files related
%to somehow to this feature.
%
%
%Selim, 28-Aug-2008 18:01:11


%
file{:} = [];
name = [];
for nv = 1:length(varargin)
    name = [name ' | grep ' varargin{nv}];
end
[a pd] = system(['find '  Folder name ' | sort' ]);
%pd = [ '.' pd(24+length(Folder):end) ];%remove the prefix/ Basically
%transform  absolute path to relative path with respect to ~/pi
if a == 0%if no error
    if ~isempty(pd);%if no file detected
        %than separate the pd into cell array
        i = regexp(pd,'\n');
        tfile = length(i);
        i = [1 i];
        %
        for nf = 1:tfile;%remove all the empty spaces and store in a cell.
            file{nf}=strtrim(pd(i(nf):i(nf+1)));
        end
    else
        file = [];
    end

else%error calling system function
    display('there is nothing returned from the system function')
end
