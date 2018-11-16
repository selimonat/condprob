function varargout = viewfeats(varargin)
% VIEWFEATS M-file for viewfeats.fig
%      VIEWFEATS, by itself, creates a new VIEWFEATS or raises the existing
%      singleton*.
%
%      H = VIEWFEATS returns the handle to a new VIEWFEATS or the handle to
%      the existing singleton*.
%
%      VIEWFEATS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VIEWFEATS.M with the given input arguments.
%
%      VIEWFEATS('Property','Value',...) creates a new VIEWFEATS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before viewfeats_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to viewfeats_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help viewfeats

% Last Modified by GUIDE v2.5 23-Dec-2009 18:32:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @viewfeats_OpeningFcn, ...
                   'gui_OutputFcn',  @viewfeats_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before viewfeats is made visible.
function viewfeats_OpeningFcn(hObject, eventdata, handles, basedir)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to viewfeats (see VARARGIN)

handles.current_feat = [];
handles.current_im = zeros(1200,1600);
handles.imnum = 0;
handles.featnum = 0;

handles.output = hObject;
handles.basedir = basedir;
handles.featuresdir = [basedir 'FeatureMaps/'];
files = dir(handles.featuresdir);
handles.features = {files(3:end).name};
set(handles.listbox2_features,'String',{'',files(3:end).name})
stdir = dir([handles.basedir 'Stimuli/']);
handles.imdir = [handles.basedir 'Stimuli/' stdir(end).name '/'];
im = dir(handles.imdir);
handles.imnames = {im(3:end).name};
set(handles.listbox1_images,'String',{'',handles.imnames{:}})

guidata(hObject, handles);

% UIWAIT makes viewfeats wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = viewfeats_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


% --- Executes on selection change in listbox1_images.
function listbox1_images_Callback(hObject, eventdata, handles)
handles.imnum = get(hObject,'Value')-1;
plotaxes(handles)
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function listbox1_images_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox2_features.
function listbox2_features_Callback(hObject, eventdata, handles)
handles.featnum = get(hObject,'Value')-1;
plotaxes(handles)
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function listbox2_features_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1_imprev.
function pushbutton1_imprev_Callback(hObject, eventdata, handles)
auximnum = get(handles.listbox1_images,'Value')-2;
if auximnum < 0
    auximnum = length(handles.imnames);
end
handles.imnum = auximnum;
set(handles.listbox1_images,'Value',auximnum+1)
plotaxes(handles)
guidata(hObject, handles);

function pushbutton2_postim_Callback(hObject, eventdata, handles)
auximnum = get(handles.listbox1_images,'Value');
if auximnum > length(handles.imnames)
    auximnum = 0;
end
handles.imnum = auximnum;
set(handles.listbox1_images,'Value',auximnum+1)
plotaxes(handles)
guidata(hObject, handles);

% --- Executes on button press in pushbutton3_prevfeat.
function pushbutton3_prevfeat_Callback(hObject, eventdata, handles)
auxfeatnum = get(handles.listbox2_features,'Value')-2;
if auxfeatnum <0
    auxfeatnum = length(handles.features);
end
handles.featnum = auxfeatnum;
set(handles.listbox2_features,'Value',auxfeatnum+1)
plotaxes(handles)
guidata(hObject, handles);


% --- Executes on button press in pushbutton4_postfeat.
function pushbutton4_postfeat_Callback(hObject, eventdata, handles)
auxfeatnum = get(handles.listbox2_features,'Value');
if auxfeatnum > length(handles.features)
    auxfeatnum = 0;
end
handles.featnum = auxfeatnum;
set(handles.listbox2_features,'Value',auxfeatnum+1)
plotaxes(handles)
guidata(hObject, handles);
