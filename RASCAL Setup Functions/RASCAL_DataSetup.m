function [] = RASCAL_DataSetup(handles )
%RASCAL_DATASETUP Summary of this function goes here
%   Detailed explanation goes here

%% Read data from data file
[DataIn, DataNames, DataLimits, FireFile]=RASCAL_Read_Data();
StartSample=14500; % fixed value for known data, should be selectable
DataIn=DataIn(StartSample:end,:);
FireData=shaperead(FireFile);

%% Set defaults
% StartSample=1;
% [DataIn, DataNames]=RASCAL_Rename_Selections(DataIn, DataNames,InitialParameters);
DDCInitialRadius=0.2;
CEDASRadius=0.2;
CEDASDecay=0;
CEDASMinThreshold=1;
DDCASRadius=CEDASRadius;
AlphaHullParams=[0.2,0,0,0.2]; % [Alpha, Hole, Region, Transparency]
TraceColours=[0.4 0.4 0.4];
ColourList=RASCAL_distinguishable_colors(26); % produce 25 distinguishable colours
ColourList([4;12;19],:)=[]; % delete those too close to black

%% Set GUI Application Data
setappdata(handles.DataGUI, 'DataIn', DataIn);
setappdata(handles.DataGUI, 'DataLimits', DataLimits);
setappdata(handles.DataGUI,'RunningData',[]);
setappdata(handles.DataGUI,'FireData', FireData);
setappdata(handles.DataGUI, 'TraceColours', TraceColours);
setappdata(handles.DataGUI, 'DDCInitialRadius', DDCInitialRadius);
setappdata(handles.DataGUI, 'CEDASRadius', CEDASRadius);
setappdata(handles.DataGUI, 'CEDASDecay', CEDASDecay);
setappdata(handles.DataGUI, 'CEDASMinThreshold', CEDASMinThreshold);
setappdata(handles.DataGUI, 'DDCASRadius', DDCASRadius);
setappdata(handles.DataGUI, 'DataNames',DataNames);
setappdata(handles.DataGUI, 'ColourList',ColourList);
setappdata(handles.DataGUI, 'AlphaHullParams', AlphaHullParams);
setappdata(handles.DataGUI, 'Groups', ones(size(DataIn,1),1));
end

