function varargout = facetracking(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name', mfilename, ...
'gui_Singleton', gui_Singleton, ...
'gui_OpeningFcn', @facetracking_OpeningFcn, ...
'gui_OutputFcn', @facetracking_OutputFcn, ...
'gui_LayoutFcn', [] , ...
'gui_Callback', []);
if nargin && ischar(varargin{1})
gui_State.gui_Callback = str2func(varargin{1});
end
if nargout
[varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
gui_mainfcn(gui_State, varargin{:});
end
function facetracking_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);
function varargout = facetracking_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;
function StartTracking_Callback(~, eventdata, handles)
a = imaqhwinfo;
camera_name = char(a.InstalledAdaptors(end));
camera_info = imaqhwinfo(camera_name);
camera_id = camera_info.DeviceInfo.DeviceID(end);
resolution = char(camera_info.DeviceInfo.SupportedFormats(end));
vid = videoinput(camera_name, camera_id, resolution);
FDetect = vision.CascadeObjectDetector('FrontalFaceCART');
set(vid, 'FramesPerTrigger', Inf);
set(vid, 'ReturnedColorspace', 'rgb')
vid.FrameGrabInterval = 5;
start(vid)
ii=22;
axes(handles.axes1);
while(vid.FramesAcquired<=200)
Dinp = getsnapshot(vid);
Dinp = uint8(Dinp);
BB = step(FDetect,Dinp);
NumberofFacestobedetected=size(BB,1);
for i = 1:NumberofFacestobedetected
imshow(Dinp);
rectangle('Position',BB(i,:),'LineWidth',5,'LineStyle','-','EdgeColor','r');
pause(0.01);
end
end
stop(vid);
flushdata(vid);
clear all
helpdlg('That was all about face tracking')

