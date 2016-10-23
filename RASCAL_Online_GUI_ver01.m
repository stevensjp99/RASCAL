function varargout = RASCAL_Online_GUI_ver01(varargin)
% RASCAL_Online_GUI_ver01 MATLAB code for RASCAL_Online_Gui_ver01.fig
% Displays:
% Trace3Plot: axes for display of flight altitude
% Alt1: data for altitude plot
% Cluster1: display of online clustering of monitored chemistry, lower left
% Cluster1: display of offline clustering of monitored chemistry, lower centre
% Cluster3: display of offline clustering of selectable chemistry
% HullOnline1: initial plot of online clustering to create handles for updating
% Trace1Plot: Axes for plot of 1st trace chemistry
% Trace1: Initial line handles for line segment of 1st trace. Subsequent 
%             segments by group created in separate function to allow line
%             colouring
% Trace2Plot: Axes for plotting of 2nd trace chemistry
% Trace2: Initial line handles for line segment of 1st trace. Subsequent 
%             segments by group created in separate function to allow line
%             colouring
% AxesMap: Display for map retrieved from google maps with overlay of
%          flight path. Uses 'plot_google_map by Zohar Bar-Yehuda:
%          http://www.mathworks.com/matlabcentral/fileexchange/27627-plotgooglemap/content/plot_google_map.m
%
% Controls:
% ClearGroupBtn: clear all selected groups
% ClusterX2: selectable x-axis chemistry for offline clustering (Cluster3)
% ClusterY2: selectable y-axis chemistry for offline clustering (Cluster3)
% DataGUI_WindowScrollWheelFcn: used to zoom in and out of plot where mouse hovers
% ExitBtn: closes GUI an halts run
% ZoomAllBtn: resets trace plot axes to full zoom out
% SelectData: pauses trace plot to allow selection of trace data. Selection
%             is only made by x-axis value
% TracePlot_ButtonDownFcn: unused
% UpdateTraceClusters: toggle button for running offline clustering (Cluster1)
% UpdateSelected2: single press button to update cluster in offlie clustering of
%             selected chemistry (Cluster3)
% Menu bar: Zoom In, Zoom Out, Pan and Data Tip, works on all plot windows

% Last Modified by R Hyde 05/10/16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @RASCAL_Online_Gui_ver01_OpeningFcn, ...
                   'gui_OutputFcn',  @RASCAL_Online_Gui_ver01_OutputFcn, ...
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


% --- Executes just before RASCAL_Online_Gui_ver01 is made visible.
function RASCAL_Online_Gui_ver01_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RASCAL_Online_Gui_ver01 (see VARARGIN)
fh.Toolbar='figure';
% Choose default command line output for RASCAL_Online_Gui_ver01
handles.output = hObject;
%% Data Setup
RASCAL_DataSetup(handles );

%% Set Trace Plots
[ handles ] = RASCAL_DisplaySetupTraces( handles );

%% Cluster Plot Positions
[ handles ] = RASCAL_DisplaySetupClusterPlots( handles );

%% Map Display
% Using google maps API function
[handles] = RASCAL_DisplaySetupGoogleMap(handles);
% To use Matlab mapping toolbox (not updated, so may be bugged!)
% [ handles ] = RASCAL_DispaySetupMatlabMap( handles );

%% Data Control Panel
[ handles ] = RASCAL_DisplaySetupDataControlPanel( handles );

%% UI COntrol Panel
[ handles ] = RASCAL_DisplaySetupUIControlPanel( handles );

%% Miscellaneous
DataNames=getappdata(handles.DataGUI,'DataNames');
handles.NewPoint=0;
linkaxes([handles.Trace1Plot, handles.Trace2Plot, handles.Trace3Plot],'x');
handles.ClustersOnLine1=struct;
handles.TC=find(strcmp([DataNames], {'TC'})); % find column for time code
handles.Lat=find(strcmp([DataNames], {'LAT-GPS'})); % find column for time code
handles.Lon=find(strcmp([DataNames], {'LON-GPS'})); % find column for time code
handles.RunningData=[]; % empty array to archive incoming data after processing
handles.DataEvent=0; % counter for the number of data samples received
handles.StartOffset=10000; % starting offset for experimental use only
handles.TraceColours=[0 0 0]; % storage for colouring data in the trace plots, also used to identify data groups selected in trace window
tic;
handles.T1=toc; % display timer store

%% ### BUG CORRECTIONS ###
% random bug always sets zoom in button to 'on', set to off.
handles.uitoggletool1.State='off';
zoom off;

%% Set timer for data retrieval
% DataTimer=timer('TimerFcn',@DataRetrieval);
DataTimer = timer('StartDelay',5,'ExecutionMode','fixedRate','Period', 0.01,'TimerFcn', {@DataRetrieval}, 'BusyMode','queue');
set(DataTimer, 'UserData', hObject)
start(DataTimer)
guidata(hObject, handles);


function GUIUpdate(obj,event,handles)
% global TraceX TraceY TracePlotAxes GroupColour Faces1 Points1

% --- Outputs from this function are returned to the command line.
function varargout = RASCAL_Online_Gui_ver01_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
varargout{1} = handles.output;


%% ### Setup Functions ###
% --- Executes during object creation, after setting all properties.
function Trace1Plot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Trace1Plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: place code in OpeningFcn to populate Trace1Plot

% --- Executes during object creation, after setting all properties.
function Trace2Plot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Trace2Plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: place code in OpeningFcn to populate Trace2Plot

% --- Executes during object creation, after setting all properties.
function Trace3Plot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Trace3Plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: place code in OpeningFcn to populate Trace3Plot

% --- Executes during object creation, after setting all properties.
function popTrace1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popTrace1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function popTrace2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popTrace2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function popTrace3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popTrace3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Cluster1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Trace1Plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: place code in OpeningFcn to populate Cluster1

function Cluster2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Trace1Plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: place code in OpeningFcn to populate Cluster1

% --- Executes during object creation, after setting all properties.
function ClusterX1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ClusterX1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function ClusterY1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ClusterY1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function ClusterX2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ClusterX2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function ClusterY2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ClusterY2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function FireConf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FireConf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% Create UI Interface Panel and Objects
function uicontrolpnl_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uicontrolpnl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function TracePlotRefreshText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TracePlotRefreshText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function TraceRefreshSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TraceRefreshSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function TraceRefreshText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TraceRefreshText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


%% ### Execution ###

% --- Executes on button press in ExitBtn.
function ExitBtn_Callback(hObject, eventdata, handles)
% hObject    handle to ExitBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(handles.DataGUI) 

% --- Executes on key press with focus on ExitBtn and none of its controls.
function ExitBtn_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to ExitBtn (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in SelectData.
function SelectData_Callback(hObject, eventdata, handles)
% hObject    handle to SelectData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in ClearGroupBtn.
function ClearGroupBtn_Callback(hObject, eventdata, handles)
% hObject    handle to ClearGroupBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
TraceColours=zeros(size(getappdata(handles.DataGUI,'TraceColours')))+0.4;
setappdata(handles.DataGUI,'TraceColours',TraceColours);
RASCAL_Online_UpdateTraceColours(handles);
% RASCAL_Online_Update_Traces(handles); % update trace plots

if ~(handles.popTrace1.Value==33 & handles.popTrace2.Value==39) % don't cluster O3 and TWC
RASCAL_Online_TraceCluster(handles); % update cluster plot
end
handles.FlightPlot1.CData=[0.4 0.4 0.4]; % update flight plot
handles.SelectData.Value=0; % reset button
handles.ClearGroupBtn.Value=0; % reset button

% --- Executes on button press in ZoomAllBtn.
function ZoomAllBtn_Callback(hObject, eventdata, handles)
% hObject    handle to ZoomAllBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
zoom(handles.Trace3Plot,'out');

% --- Executes on mouse press over axes background.
function Trace3Plot_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to Trace3Plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% k = waitforbuttonpress;
handles.MouseClick = get(gcbf, 'SelectionType');
Point1 = get(gca,'CurrentPoint'); % button down detected
Point1 = ceil(Point1(1,1:1));
Point1=find(handles.Trace3.XData==Point1); % find position of TC data in running data array
if handles.SelectData.Value==1;
    if strcmp(handles.MouseClick,'normal') || strcmp(handles.MouseClick,'alt') 
    RASCAL_Online_TraceGroups(handles,Point1);
    % Update trace plot colours
    TraceColours=getappdata(handles.DataGUI,'TraceColours');
%     TraceColours=TraceColours(1:handles.DataEvent,:);
    set(handles.Trace1,'CData',TraceColours);
    set(handles.Trace2,'CData',TraceColours);
    set(handles.Trace3,'CData',TraceColours);
    % update flight path colours

%     RASCAL_Online_Update_Traces(handles); % update trace plots
    if ~(handles.popTrace1.Value==33 & handles.popTrace2.Value==39) % don't cluster O3 and TWC
    RASCAL_Online_TraceCluster(handles);
    end
    
    handles.MouseClick=[];
    handles.NewPoint=0;
    end
end
guidata(handles.DataGUI, handles);

% --- Executes on selection change in popTrace1.
function popTrace1_Callback(hObject, eventdata, handles, DataIn)
% hObject    handle to popTrace1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popTrace1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popTrace1
RASCAL_Online_ChangeTraces(handles);

% --- Executes on selection change in popTrace2.
function popTrace2_Callback(hObject, eventdata, handles)
% hObject    handle to popTrace2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns popTrace2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popTrace2
RASCAL_Online_ChangeTraces(handles);

% --- Executes on selection change in popTrace3.
function popTrace3_Callback(hObject, eventdata, handles)
% hObject    handle to popTrace3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popTrace3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popTrace3
RASCAL_Online_ChangeTraces(handles);

% --- Executes on scroll wheel click while the figure is in focus.
function DataGUI_WindowScrollWheelFcn(hObject, eventdata, handles)
% hObject    handle to DataGUI (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	VerticalScrollCount: signed integer indicating direction and number of clicks
%	VerticalScrollAmount: number of lines scrolled for each click
% handles    structure with handles and user data (see GUIDATA)
% ZoomFactor=10;
% get(hObject,'WindowScrollWheelFcn');
% FigZoom=eventdata.VerticalScrollCount;
% hZoom=zoom;
ZoomDirn=eventdata.VerticalScrollCount;

if strcmp(eventdata.Source.CurrentAxes.Tag,'Trace3Plot') % code to zoom trace plots
    zoom(handles.Trace3Plot,'xon');
    if ZoomDirn==-1
        zoom(handles.Trace3Plot,1.1);
    elseif ZoomDirn==1
        zoom(handles.Trace3Plot,0.9);
    end
    zoom(handles.Trace3Plot,'off');
else%if strcmp(eventdata.Source.CurrentAxes.Tag,'MapPlot') % code to zoom trace plots
    zoom('on');
    if ZoomDirn==-1
        zoom(gca,1.1);
    elseif ZoomDirn==1
        zoom(gca,0.9);
    end
    zoom('off');
    
end % end if flight plot

% --- Executes on selection change in ClusterX1.
function ClusterX1_Callback(hObject, eventdata, handles)
% hObject    handle to ClusterX1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns ClusterX1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ClusterX1

% --- Executes on selection change in ClusterY1.
function ClusterY1_Callback(hObject, eventdata, handles)
% hObject    handle to ClusterY1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns ClusterY1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ClusterY1

% --- Executes on selection change in ClusterX2.
function ClusterX2_Callback(hObject, eventdata, handles)
% hObject    handle to ClusterX2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ClusterX2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ClusterX2
SelectCluster=handles.SelectCluster;
SelectCluster(1,1)=cell2mat({get(hObject,'Value')});
SelectCluster(1,2)=SelectCluster(1,2);
handles.SelectCluster=SelectCluster;
guidata(hObject,handles);

% --- Executes on selection change in ClusterY2.
function ClusterY2_Callback(hObject, eventdata, handles)
% hObject    handle to ClusterY2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ClusterY2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ClusterY2
SelectCluster=handles.SelectCluster;
SelectCluster(1,2)=cell2mat({get(hObject,'Value')});
SelectCluster(1,1)=SelectCluster(1,1);
handles.SelectCluster=SelectCluster;
guidata(hObject,handles);
% --- Executes on button press in UpdateSelected1.

% --- Executes on button press in ZoomAll.
function ZoomAll_Callback(hObject, eventdata, handles)
% hObject    handle to ZoomAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% zoom(handles.Trace3Plot,'out');
Data=getappdata(handles.DataGUI,'RunningData');
handles.Trace1Plot.XLim=[Data(1,handles.TC),Data(end,handles.TC)];

function UpdateSelected1_Callback(hObject, eventdata, handles)
% hObject    handle to UpdateSelected1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
RASCAL_Online_ClusterPlots(handles, 2);

function UpdateSelected2_Callback(hObject, eventdata, handles)
% hObject    handle to UpdateSelected2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
RASCAL_Online_ClusterPlots(handles, 3);

% --- Executes on button press in FireBtn.
function FireBtn_Callback(hObject, eventdata, handles)
% hObject    handle to FireBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of FireBtn
if ~size(findobj(handles.AxesMap,'Tag','FireDisplay'),1) & get(hObject,'Value')==1
    FireData=getappdata(handles.DataGUI,'FireData');
    FireConfMin=floor(get(hObject,'Value'));
    idx1=find([FireData(1:end).CONFIDENCE]>FireConfMin);
    handles.FireDisplay=scatter(handles.AxesMap,[FireData(idx1).X],[FireData(idx1).Y],5,'r*');
    handles.FireDisplay.Tag='FireDisplay';
else
FireObj=findobj(handles.AxesMap,'Tag','FireDisplay');
switch get(hObject,'Value');
    case 0 % off
        FireObj.Visible='off';
    case 1 % On
        FireObj.Visible='on';
end
end

function FireConf_Callback(hObject, eventdata, handles)
% hObject    handle to FireConf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of FireConf as text
%        str2double(get(hObject,'String')) returns contents of FireConf as a double
if size(findobj(handles.AxesMap,'Tag','FireDisplay'),1)
FireConfMin=floor(get(hObject,'Value'));
handles.FireConfDisp.String=FireConfMin;
FireData=getappdata(handles.DataGUI,'FireData');
handles.FireConfDisp.Value=FireConfMin;
idx1=find([FireData(1:end).CONFIDENCE]>=FireConfMin);
FireObj=findobj(handles.AxesMap,'Tag','FireDisplay');
FireObj.XData=[FireData(idx1).X];
FireObj.YData=[FireData(idx1).Y];
end

% --- Executes during object creation, after setting all properties.
function FireConfDisp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FireConfDisp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function FireConfDisp_Callback(hObject, eventdata, handles)
% hObject    handle to FireConfDisp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FireConfDisp as text
%        str2double(get(hObject,'String')) returns contents of FireConfDisp as a double
if size(findobj(handles.AxesMap,'Tag','FireDisplay'),1)
FireConfMin=floor(str2double(get(hObject,'String')));
handles.FireConf.Value=FireConfMin;
FireData=getappdata(handles.DataGUI,'FireData');
idx1=find([FireData(1:end).CONFIDENCE]>=FireConfMin);
FireObj=findobj(handles.AxesMap,'Tag','FireDisplay');
FireObj.XData=[FireData(idx1).X];
FireObj.YData=[FireData(idx1).Y];
end

% --- Executes on mouse press over axes background.
function Cluster2_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to Cluster2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.SelectData.Value==1; % if select button is down
    
    Select=impoly(handles.Cluster2);
    if size(Select)>0
    SelectShape=getPosition(Select);
    handles.Cluster2.XLimMode='auto';
    handles.Cluster2.YLimMode='auto';
    
    DataSelection=[handles.ClusterX1.Value,handles.ClusterY1.Value];
    RASCAL_Online_FindClusterData(handles, SelectShape, DataSelection);
    
    RASCAL_Online_GroupDisplay(handles,2);
    end
end

% --- Executes on mouse press over axes background.
function Cluster3_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to Cluster3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.SelectData.Value==1; % if select button is down
    Select=impoly(handles.Cluster3);
    SelectShape=getPosition(Select);
    handles.Cluster3.XLimMode='auto';
    handles.Cluster3.YLimMode='auto';
    
%     DataSelection=[handles.ClusterX2.Value,handles.ClusterY2.Value];
%     
%     RASCAL_Online_GroupDisplay(handles,3);
end

function TracePlotRefreshText_Callback(hObject, eventdata, handles)
% hObject    handle to TracePlotRefreshText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TracePlotRefreshText as text
%        str2double(get(hObject,'String')) returns contents of TracePlotRefreshText as a double
T=round(str2num(hObject.String),1);
if T<0.1
    T=0.1;
end
hObject.Value=T;
hObject.String=num2str(T);
handles.TraceRefreshSlider.Value=T;


% --- Executes on slider movement.
function TraceRefreshSlider_Callback(hObject, eventdata, handles)
% hObject    handle to TraceRefreshSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
T=handles.TraceRefreshSlider.Value;
if T<0.1
    T=0.1;
end
handles.TracePlotRefreshText.Value=T;
handles.TracePlotRefreshText.String=num2str(T);

%% ### Not Yet Implemented ###


function AxesMap_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to AxesMap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on mouse press over axes background.
function Trace1Plot_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to Trace1Plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in UpdateSelected2.

function UpdateTraceClusters_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to UpdateTraceClusters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on selection change in popupmenu9.
function popupmenu9_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu9 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu9


% --- Executes during object creation, after setting all properties.
function popupmenu9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% ### Test Functions ###


% --- Executes on mouse press over axes background.


% --- Executes on button press in SaveBtn.
function SaveBtn_Callback(hObject, eventdata, handles)
% hObject    handle to SaveBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- execute on timer
function DataRetrieval(hObject, eventdata)
handles=guidata(hObject.UserData);

% do not run unless all traces selected
if handles.popTrace1.Value>1 & handles.popTrace2.Value>1 & handles.popTrace3.Value>1

    [handles]=RASCAL_Online_GetDataSample(handles);

    [handles]=RASCAL_Online_Update_Traces(handles);

    % Update Online Clustering
    [handles]=RASCAL_Online_TraceCluster(handles);

    % update flight position data
    [handles]=RASCAL_Online_UpdateFlightPath(handles);
    if toc-handles.T1>handles.TraceRefreshSlider.Value
        drawnow
        handles.T1=toc;
        guidata(handles.DataGUI,handles) % update GUI data
    end
end
