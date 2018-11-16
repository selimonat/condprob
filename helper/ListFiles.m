function [f]=ListFiles(s)
%[f]=ListFiles(s)
%uses the DIR utility. Returns in a cell array all the files including "."
%and ".."
%
%Example Usage:
%
%ListFiles('*.mat') returns all the .mat files in the current directory.
%
%Selim 15.Nov.2006
f = dir(s);
f = {f.name};