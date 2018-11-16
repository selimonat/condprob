function [map,nPix]=CropperCleaner(map,varargin)
%[map,Npix]=CropperCleaner(map,varargin)
%
% This function is used to remove the zeros of the zero-padding or to crop
% a specified amount of pixels from the 2D feature maps. 
%
% In its default mode, i.e without VARARGIN, it detects automatically
% the zero padded regions and removes them and it returns the amount of
% pixels removed in NPIX.
%
% In case the varargin is provided but is empty then the function still
% operates in its default mode.
%
% In case the varargin is a scalar that amount of pixels is removed from
% both edges in both dimensions, as a consequenct nPix is equal to
% varargin{1}. 
%
% Assumes same amount of padding in the both of the dimensions and edges
% when operating in deafult mode.
%
%Version 1.0; 16.10.2006
%
% %Selim Onat AND Frank Schumann, (2006), any comments, questions etc. can be
%mailed to {sonat,fschuman}@uos.de
%
% Selim, 22-Dec-2007 15:37:14, improved the way how the zeropad amount is
% detected.



if isempty(varargin);    %if no varargin is given then we are detecting the zeros automatically and removing them.
    %sum over two cardinal axis
    h = sum(map(:,:,1));    
    %detect the occurence of the first zero
    %and assume it as the padding size
    nPix = min(find( h ~=0))-1;%NPIX is the amount of zeros.    
    %cleaning stage    
    map  = map(nPix+1:end-nPix,nPix+1:end-nPix,:);        

else    %if varargin is provided, we first check whether it is not empty.

    if ~isempty(varargin{1})%and if it is not empty we crop 
        nPix = varargin{1};
        %cleaning stage
        map  = map(nPix+1:end-nPix,nPix+1:end-nPix,:);    
    else%otherwise we automatically remove the zeros as above.
            %sum over two cardinal axis
        
        %we want to have 4 estimates of the zero-padding amount twice for
        %each dimension:
        mapsum1 = sum(map(:,:,1));%these the two marjinals
        mapsum2 = sum(map(:,:,1)');
        %detect the first non-zero elements
        h(1) = find(  mapsum1~= 0 , 1);
        h(2) = find(  fliplr(mapsum1) ~= 0 , 1);
        h(3) = find(  mapsum2~= 0 , 1);
        h(4) = find(  fliplr(mapsum2) ~= 0 , 1);
        % In a featuremap which is not mainly dominated with zero values
        % such as LC or ML maps, the 4 estimations of the zero-pad amount is 
        % mostly likely equal. however this is not true always. For example
        % in the map LUM_PS_WL_192 you may not get four of the estimations
        % the same. 
        % we take the min of the 4 estimations
        nPix = min(h)-1;%NPIX is the amount of zeros.
        %cleaning stage
        map  = map(nPix+1:end-nPix,nPix+1:end-nPix,:);        
        %return an error message in case the estimation is not reliable.
        if (length(h)-length(unique(h)))./(length(h)-1) < 0.5
            display('automatic estimation of the zero-pad amount did not reach a reliable estimate')
            display('to avoid the featuremap to be wrongly cropped CA is set to zero!')
            nPix = 0;
        end
    end
end
