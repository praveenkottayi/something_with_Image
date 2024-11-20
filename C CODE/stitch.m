function varargout = stitch(varargin)
% STITCH M-file for stitch.fig
%      STITCH, by itself, creates a new STITCH or raises the existing
%      singleton*.
%
%      H = STITCH returns the handle to a new STITCH or the handle to
%      the existing singleton*.
%
%      STITCH('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STITCH.M with the given input arguments.
%
%      STITCH('Property','Value',...) creates a new STITCH or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before stitch_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to stitch_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help stitch

% Last Modified by GUIDE v2.5 14-Apr-2011 08:11:23

% Author: Arun D Panicker, April 2011

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @stitch_OpeningFcn, ...
    'gui_OutputFcn',  @stitch_OutputFcn, ...
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


% --- Executes just before stitch is made visible.
function stitch_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to stitch (see VARARGIN)

% Choose default command line output for stitch

handles.output = hObject;

% user-defined variables for global use
handles.radI = 1;           % image radio button on/off
handles.radV = 0;           % video radio button on/off
handles.radL = 0;           % live radio button on/off
handles.filename1 = ' ';    % input 1 filename
handles.pathname1 = ' ';    % input 1 path
handles.filename2 = ' ';    % input 2 filename
handles.pathname2 = ' ';    % input 2 path
handles.h = 240;            % height for image/frame resize
handles.w = 320;            % width for image/frame resize
handles.blend = 25;         % no. of pixels(width) for blending
handles.stop = 0;           % interrupt to stop video stitch

% initial settings for buttons
set(handles.stopButton,'Visible','off');
set(handles.stopButton,'Enable','off');
set(handles.stitchButton,'Enable','off');
set(handles.status, 'String', ' ');
set(handles.input1button,'Visible','on');
set(handles.input1button,'Enable','on');
set(handles.input2button,'Visible','on');
set(handles.input2button,'Enable','on');
set(handles.camera1Popup,'Visible','off');
set(handles.camera1Popup,'Enable','off');
set(handles.camera2Popup,'Visible','off');
set(handles.camera2Popup,'Enable','off');

% clean up axes
axes(handles.axes1); axis off; cla;
axes(handles.axes2); axis off; cla;
axes(handles.axes3); axis off; cla;
axes(handles.axes4); axis off; cla;

caminfo = imaqhwinfo('winvideo');
numOfCameras = size(caminfo.DeviceInfo, 2);
cameras = caminfo.DeviceInfo;

camNames = cell(numOfCameras,1);
camNames(1) = cellstr('-- select --');
for i = 1:numOfCameras
    camNames(i+1) = cellstr(cameras(i).DeviceName);
end;
handles.strCamNames = char(camNames);
set(handles.camera1Popup,'String',handles.strCamNames);
set(handles.camera2Popup,'String',handles.strCamNames);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes stitch wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = stitch_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in input1button.
function input1button_Callback(hObject, eventdata, handles)

% image input
if (handles.radI == 1)
    [f, p] =...
        uigetfile({'*.jpg; *.png; *.bmp',...
        'Image Files(*.jpg,*.png,*.bmp)';...
        '*.*', 'All Files(*.*)'}, ...
        'Select Image 1');
    axes(handles.axes1);
    if(f == 0)
        cla;
        handles.filename1 = ' ';
        handles.pathname1 = ' ';
    else
        handles.filename1 = f;
        handles.pathname1 = p;
        I=imread([handles.pathname1 handles.filename1]);
        imshow(I);
    end;
    % video input
elseif (handles.radV == 1)
    [f, p] =...
        uigetfile({'*.avi', 'AVI Files(*.avi)';...
        '*.mpg; *.mpeg; *.avi', 'Video Files(*.mpg,*.mpeg,*.avi)';...
        '*.*', 'All Files(*.*)'}, ...
        'Select Image 1');
    axes(handles.axes1);
    if(f == 0)
        cla;
        handles.filename1 = ' ';
        handles.pathname1 = ' ';
    else
        handles.filename1 = f;
        handles.pathname1 = p;
        video = aviread([handles.pathname1 handles.filename1]);
        I = double(video(1).cdata);
        imshow(I/255);
    end;
    % live input
elseif (handles.radL == 1)
    os = computer;
    if(strcmp(os, 'PCWIN') == 0)
        msgbox('plugin not available');
    end;
end;
% enable/disable 'stitch' button
if((length(handles.filename1) > 4) && (length(handles.filename2) > 4))
    set(handles.stitchButton,'Enable','on');
else
    set(handles.stitchButton,'Enable','off');
end;
guidata(hObject, handles);


% --- Executes on button press in input2button.
function input2button_Callback(hObject, eventdata, handles)

% image input
if (handles.radI == 1)
    [f, p] =...
        uigetfile({'*.jpg; *.png; *.bmp',...
        'Image Files(*.jpg,*.png,*.bmp)';...
        '*.*', 'All Files(*.*)'}, ...
        'Select Image 2');
    axes(handles.axes2);
    if(f == 0)
        cla;
        handles.filename2 = ' ';
        handles.pathname2 = ' ';
    else
        handles.filename2 = f;
        handles.pathname2 = p;
        I=imread([handles.pathname2 handles.filename2]);
        imshow(I);
    end;
    % video input
elseif (handles.radV == 1)
    [f, p] =...
        uigetfile({'*.avi', 'AVI Files(*.avi)';...
        '*.mpg; *.mpeg; *.avi', 'Video Files(*.mpg,*.mpeg,*.avi)';...
        '*.*', 'All Files(*.*)'}, ...
        'Select Image 1');
    axes(handles.axes2);
    if(f == 0)
        cla;
        handles.filename2 = ' ';
        handles.pathname2 = ' ';
    else
        handles.filename2 = f;
        handles.pathname2 = p;
        video = aviread([handles.pathname2 handles.filename2]);
        I = double(video(1).cdata);
        imshow(I/255);
    end;
    % live input
elseif (handles.radL == 1)
    os = computer;
    if(strcmp(os, 'PCWIN') == 0)
        msgbox('plugin not available');
    end;
end;
% enable/disable 'stitch' button
if((length(handles.filename1) > 4) && (length(handles.filename2) > 4))
    set(handles.stitchButton,'Enable','on');
else
    set(handles.stitchButton,'Enable','off');
end;
guidata(hObject, handles);

% --- Executes when selected object is changed in uipanel1.
function uipanel1_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel1
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

switch get(hObject,'Tag')   % Get Tag of selected object
    case 'radioImage'
        handles.radI=1;
        handles.radV=0;
        handles.radL=0;
        handles.filename1 = ' ';
        handles.pathname1 = ' ';
        handles.filename2 = ' ';
        handles.pathname2 = ' ';
        set(handles.stopButton,'Visible','off');
        set(handles.stopButton,'Enable','off');
        set(handles.stitchButton,'Enable','off');
        set(handles.status, 'String', ' ');
        set(handles.input1button,'Visible','on');
        set(handles.input1button,'Enable','on');
        set(handles.input2button,'Visible','on');
        set(handles.input2button,'Enable','on');
        set(handles.camera1Popup,'Visible','off');
        set(handles.camera1Popup,'Enable','off');
        set(handles.camera2Popup,'Visible','off');
        set(handles.camera2Popup,'Enable','off');
        axes(handles.axes1); axis off; cla;
        axes(handles.axes2); axis off; cla;
        axes(handles.axes3); axis off; cla;
        axes(handles.axes4); axis off; cla;
        guidata(hObject, handles);
    case 'radioVideo'
        handles.radI=0;
        handles.radV=1;
        handles.radL=0;
        handles.filename1 = ' ';
        handles.pathname1 = ' ';
        handles.filename2 = ' ';
        handles.pathname2 = ' ';
        set(handles.stopButton,'Visible','on');
        set(handles.stopButton,'Enable','off');
        set(handles.stitchButton,'Enable','off');
        set(handles.status, 'String', ' ');
        set(handles.input1button,'Visible','on');
        set(handles.input1button,'Enable','on');
        set(handles.input2button,'Visible','on');
        set(handles.input2button,'Enable','on');
        set(handles.camera1Popup,'Visible','off');
        set(handles.camera1Popup,'Enable','off');
        set(handles.camera2Popup,'Visible','off');
        set(handles.camera2Popup,'Enable','off');
        axes(handles.axes1); axis off; cla;
        axes(handles.axes2); axis off; cla;
        axes(handles.axes3); axis off; cla;
        axes(handles.axes4); axis off; cla;
        guidata(hObject, handles);
    case 'radioLive'
        handles.radI=0;
        handles.radV=0;
        handles.radL=1;
        handles.filename1 = ' ';
        handles.pathname1 = ' ';
        handles.filename2 = ' ';
        handles.pathname2 = ' ';
        set(handles.stopButton,'Visible','on');
        set(handles.stopButton,'Enable','off');
        set(handles.stitchButton,'Enable','off');
        set(handles.status, 'String', ' ');
        axes(handles.axes1); axis off; cla;
        axes(handles.axes2); axis off; cla;
        axes(handles.axes3); axis off; cla;
        axes(handles.axes4); axis off; cla;
        os = computer;
        if(strcmp(os, 'PCWIN'))
            set(handles.input1button,'Visible','off');
            set(handles.input1button,'Enable','off');
            set(handles.input2button,'Visible','off');
            set(handles.input2button,'Enable','off');
            set(handles.camera1Popup,'Visible','on');
            set(handles.camera1Popup,'Enable','on');
            set(handles.camera2Popup,'Visible','on');
            set(handles.camera2Popup,'Enable','on');
        else
            set(handles.input1button,'Visible','on');
            set(handles.input1button,'Enable','on');
            set(handles.input2button,'Visible','on');
            set(handles.input2button,'Enable','on');
            set(handles.camera1Popup,'Visible','off');
            set(handles.camera1Popup,'Enable','off');
            set(handles.camera2Popup,'Visible','off');
            set(handles.camera2Popup,'Enable','off');
        end;
        guidata(hObject, handles);
end

% --- Executes on button press in stitchButton.
function stitchButton_Callback(hObject, eventdata, handles)

% image stitch
axes(handles.axes3); axis off; cla;
axes(handles.axes4); axis off; cla;
drawnow;
if (handles.radI == 1)
    % input
    imageIn1 = [handles.pathname1 handles.filename1];
    imageIn2 = [handles.pathname2 handles.filename2];
    I1 = imreadbw(imageIn1);
    I2 = imreadbw(imageIn2);
    I1=imresize(I1, [handles.h handles.w]);
    I2=imresize(I2, [handles.h handles.w]);
    I1=I1-min(I1(:)) ;
    I1=I1/max(I1(:)) ;
    I2=I2-min(I2(:)) ;
    I2=I2/max(I2(:)) ;
    
    try
        % SIFT
        set(handles.status, 'String',...
            'Finding SIFT features for image 1...');
        drawnow;
        [frames1,descr1,gss1,dogss1] = do_sift( I1, 'Verbosity', 1,...
            'NumOctaves', 4, 'Threshold',  0.1/3/2 ) ;
        set(handles.status, 'String',...
            'Finding SIFT features for image 1...');
        drawnow;
        [frames2,descr2,gss2,dogss2] = do_sift( I2, 'Verbosity', 1,...
            'NumOctaves', 4, 'Threshold',  0.1/3/2 ) ;
        descr1 = descr1';
        descr2 = descr2';
        
        [matches, pts1, pts2]=do_match(I1, descr1, frames1',I2, descr2,...
            frames2', handles.axes3) ;
    catch ME
        set(handles.status, 'String', 'Error...');
        matches = 1;
    end;
    
    if (matches > 5)
        Irgb1=imread(imageIn1);
        Irgb2=imread(imageIn2);
        Irgb1=imresize(Irgb1, [handles.h handles.w]);
        Irgb2=imresize(Irgb2, [handles.h handles.w]);
        
        % RANSAC
        set(handles.status, 'String',...
            'Computing tranformation settings...');
        drawnow;
        H = do_ransac(pts1, pts2);
        set(handles.status, 'String', 'Constructing Lookup Table...');
        drawnow;
        T = create_table(Irgb1, Irgb2, H, handles.blend);
        
        set(handles.status, 'String', 'Stitching images');
        drawnow;
        imageOut = do_stitch(Irgb1, Irgb2, T);
        axes(handles.axes4), imshow(imageOut/255); axis equal;
        set(handles.status, 'String', 'Stitching complete...');
        
        % save output
        [FileName,PathName] = ...
            uiputfile({'*.png', 'PNG Image File(*.png)'},...
            'Save Stitched Output As', 'output.png');
        if(FileName == 0)
            set(handles.status, 'String', 'Output not saved...');
        else
            imwrite(imageOut/255, [PathName FileName]);
            set(handles.status, 'String', 'Saved stitched output...');
        end;
    else
        set(handles.status, 'String', ...
            'Unable to find sufficient features for auto stitch...');
    end;
    % video stitch
elseif (handles.radV == 1)
    handles.stop = 0;
    set(handles.stopButton,'Enable','on');
    % input
    file1 = [handles.pathname1 handles.filename1];
    file2 = [handles.pathname2 handles.filename2];
    s = sprintf('Opening file %s...', handles.filename1);
    set(handles.status, 'String', s);
    drawnow;
    video1 = aviread(file1);
    s = sprintf('Opening file %s...', handles.filename2);
    set(handles.status, 'String', s);
    drawnow;
    video2 = aviread(file2);
    
    % assuming both videos are equal in length
    totalFrames = min(size(video1, 2), size(video2, 2));
    
    % use first frame to compute transformation
    Irgb1 = double(video1(1).cdata);
    Irgb2 = double(video2(1).cdata);
    Irgb1=imresize(Irgb1, [handles.h handles.w]);
    Irgb2=imresize(Irgb2, [handles.h handles.w]);
    I1 = rgb2gray(Irgb1/255);
    I2 = rgb2gray(Irgb2/255);
    I1=I1-min(I1(:)) ;
    I1=I1/max(I1(:)) ;
    I2=I2-min(I2(:)) ;
    I2=I2/max(I2(:)) ;
    
    try
        % SIFT
        set(handles.status, 'String',...
            'Finding SIFT features for video 1...');
        drawnow;
        [frames1,descr1,gss1,dogss1] = do_sift( I1, 'Verbosity', 1,...
            'NumOctaves', 4, 'Threshold',  0.1/3/2 ) ;
        set(handles.status, 'String',...
            'Finding SIFT features for video 2...');
        drawnow;
        [frames2,descr2,gss2,dogss2] = do_sift( I2, 'Verbosity', 1,...
            'NumOctaves', 4, 'Threshold',  0.1/3/2 ) ;
        set(handles.status, 'String', 'Computing matches...') ;
        drawnow;
        descr1 = descr1';
        descr2 = descr2';
        [matches, pts1, pts2]=do_match(I1, descr1, frames1',I2, descr2,...
            frames2', handles.axes3) ;
        s = sprintf('Found %d matches...', matches) ;
        set(handles.status, 'String', s);
        drawnow;
    catch ME
        set(handles.status, 'String', 'Error...');
        matches = 1;
    end;
    if (matches > 5)
        % RANSAC
        set(handles.status, 'String',...
            'Computing tranformation settings...');
        drawnow;
        H = do_ransac(pts1, pts2);
        set(handles.status, 'String', 'Constructing Lookup Table...');
        drawnow;
        
        T = create_table(Irgb1, Irgb2, H, handles.blend);
        clear F;
        j = 1;
        set(handles.status, 'String', 'Initialising Stitching');
        i = 1;
        % stitch each frame till the end of video or
        %   till the 'stop' button is pressed
        while((i <= totalFrames) && (handles.stop == 0))
            % load each frame for stitching
            Irgb1 = double(video1(i).cdata);
            Irgb2 = double(video2(i).cdata);
            Irgb1=imresize(Irgb1, [handles.h handles.w]);
            Irgb2=imresize(Irgb2, [handles.h handles.w]);
            imageOut = do_stitch(Irgb1, Irgb2, T);
            axes(handles.axes1), imshow(Irgb1/255);
            axes(handles.axes2), imshow(Irgb2/255);
            axes(handles.axes4), imshow(imageOut/255); axis equal;
            s = sprintf('stitching frame %d/%d', i, totalFrames);
            set(handles.status, 'String', s);
            drawnow;
            F(j) = getframe;
            j = j + 1;
            i = i + 1;
            s = get(handles.stopButton,'Enable');
            if strcmp(s, 'off')
                handles.stop = 1;
            end;
        end;
        set(handles.stopButton,'Enable','off');
        set(handles.status, 'String', 'Stitching complete...');
        
        % save output
        [FileName,PathName] = uiputfile({'*.avi', 'AVI File(*.avi)'},...
            'Save Stitched Output As', 'output.avi');
        if(FileName == 0)
            set(handles.status, 'String', 'Output not saved...');
        else
            movie2avi(F, [PathName FileName]);
            set(handles.status, 'String', 'Saved stitched output...');
        end;
    else
        set(handles.status, 'String', ...
            'Unable to find sufficient features for auto stitch...');
    end;
elseif (handles.radL == 1)
    %     msgbox('hi Live');
    handles.stop = 0;
    set(handles.stopButton,'Enable','on');
    % input
    cam1 = get(handles.camera1Popup, 'Value') - 1;
    cam2 = get(handles.camera2Popup, 'Value') - 1;
    s = sprintf('Initializing %s...',...
        strtrim(handles.strCamNames(cam1, :)));
    set(handles.status, 'String', s);
    drawnow;
    video1 = videoinput('winvideo',cam1,'YUY2_320x240');
    set(video1,'ReturnedColorSpace','rgb');
    start(video1);
    s = sprintf('Initializing %s...',...
        strtrim(handles.strCamNames(cam2, :)));
    set(handles.status, 'String', s);
    drawnow;
    video2 = videoinput('winvideo',cam2,'YUY2_320x240');
    set(video2,'ReturnedColorSpace','rgb');
    start(video2);
    
    % use first frame to compute transformation
    flushdata(video1);
    flushdata(video2);
    Irgb1 = double(getsnapshot(video1));
    Irgb2 = double(getsnapshot(video2));
    %     Irgb1=imresize(Irgb1, [handles.h handles.w]);
    %     Irgb2=imresize(Irgb2, [handles.h handles.w]);
    I1 = rgb2gray(Irgb1/255);
    I2 = rgb2gray(Irgb2/255);
    I1=I1-min(I1(:)) ;
    I1=I1/max(I1(:)) ;
    I2=I2-min(I2(:)) ;
    I2=I2/max(I2(:)) ;
    
    axes(handles.axes1), imshow(Irgb1/255);
    axes(handles.axes2), imshow(Irgb2/255);
    
    try
        % SIFT
        set(handles.status, 'String',...
            'Finding SIFT features for video 1...');
        drawnow;
        [frames1,descr1,gss1,dogss1] = do_sift( I1, 'Verbosity', 1,...
            'NumOctaves', 4, 'Threshold',  0.1/3/2 ) ;
        set(handles.status, 'String',...
            'Finding SIFT features for video 2...');
        drawnow;
        [frames2,descr2,gss2,dogss2] = do_sift( I2, 'Verbosity', 1,...
            'NumOctaves', 4, 'Threshold',  0.1/3/2 ) ;
        set(handles.status, 'String', 'Computing matches...') ;
        drawnow;
        descr1 = descr1';
        descr2 = descr2';
        [matches, pts1, pts2]=do_match(I1, descr1, frames1',I2, descr2,...
            frames2', handles.axes3) ;
        s = sprintf('Found %d matches...', matches) ;
        set(handles.status, 'String', s);
        drawnow;
    catch ME
        set(handles.status, 'String', ...
            'Error...');
        matches = 1;
    end;
    if (matches > 5)
        % RANSAC
        set(handles.status, 'String',...
            'Computing tranformation settings...');
        drawnow;
        H = do_ransac(pts1, pts2);
        set(handles.status, 'String', 'Constructing Lookup Table...');
        drawnow;
        
        T = create_table(Irgb1, Irgb2, H, handles.blend);
        clear F;
        j = 1;
        set(handles.status, 'String', 'Initialising Stitching');
        i = 1;
        % stitch each frame till the end of video or
        %   till the 'stop' button is pressed
        while(handles.stop == 0)
            % load each frame for stitching
            flushdata(video1);
            flushdata(video2);
            Irgb1 = double(getsnapshot(video1));
            Irgb2 = double(getsnapshot(video2));
            %             Irgb1=imresize(Irgb1, [handles.h handles.w]);
            %             Irgb2=imresize(Irgb2, [handles.h handles.w]);
            imageOut = do_stitch(Irgb1, Irgb2, T);
            axes(handles.axes1), imshow(Irgb1/255);
            axes(handles.axes2), imshow(Irgb2/255);
            axes(handles.axes4), imshow(imageOut/255); axis equal;
            s = sprintf('stitching frame %d', i);
            set(handles.status, 'String', s);
            drawnow;
            F(i) = getframe;
            i = i + 1;
            s = get(handles.stopButton,'Enable');
            if strcmp(s, 'off')
                handles.stop = 1;
            end;
        end;
        set(handles.status, 'String', 'Stitching complete...');
        stop(video1);
        stop(video2);
        delete(video1);
        delete(video2);
        % save output
        [FileName,PathName] = uiputfile({'*.avi', 'AVI File(*.avi)'},...
            'Save Stitched Output As', 'output.avi');
        if(FileName == 0)
            set(handles.status, 'String', 'Output not saved...');
        else
            movie2avi(F, [PathName FileName]);
            set(handles.status, 'String', 'Saved stitched output...');
        end;
    else
        set(handles.status, 'String', ...
            'Unable to find sufficient features for auto stitch...');
    end;
    set(handles.stopButton,'Enable','off');
end;


% --- Executes on button press in stopButton.
function stopButton_Callback(hObject, eventdata, handles)

handles.stop = 1;
set(handles.stopButton,'Enable','off');
guidata(hObject, handles);


% --- Executes on selection change in camera1Popup.
function camera1Popup_Callback(hObject, eventdata, handles)
% hObject    handle to camera1Popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cam1 = get(handles.camera1Popup, 'Value') - 1;
cam2 = get(handles.camera2Popup, 'Value') - 1;
if(cam1 > 0)
    video = videoinput('winvideo',cam1,'YUY2_320x240');
    set(video,'ReturnedColorSpace','rgb');
    start(video);
    I = getsnapshot(video);
    axes(handles.axes1), imshow(I);
    stop(video);
    delete(video);
end;
if ((cam1 ~= cam2) && (cam1 > 0) && (cam2 > 0))
    set(handles.stitchButton,'Enable','on');
else
    set(handles.stitchButton,'Enable','off');
end;
guidata(hObject, handles);
% Hints: contents = cellstr(get(hObject,'String')) returns camera1Popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from camera1Popup


% --- Executes during object creation, after setting all properties.
function camera1Popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to camera1Popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in camera2Popup.
function camera2Popup_Callback(hObject, eventdata, handles)
% hObject    handle to camera2Popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cam1 = get(handles.camera1Popup, 'Value') - 1;
cam2 = get(handles.camera2Popup, 'Value') - 1;
if(cam2 > 0)
    video = videoinput('winvideo',cam2,'YUY2_320x240');
    set(video,'ReturnedColorSpace','rgb');
    start(video);
    I = getsnapshot(video);
    axes(handles.axes2), imshow(I);
    stop(video);
    delete(video);
end;
if ((cam1 ~= cam2) && (cam1 > 0) && (cam2 > 0))
    set(handles.stitchButton,'Enable','on');
else
    set(handles.stitchButton,'Enable','off');
end;
guidata(hObject, handles);
% Hints: contents = cellstr(get(hObject,'String')) returns camera2Popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from camera2Popup


% --- Executes during object creation, after setting all properties.
function camera2Popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to camera2Popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
