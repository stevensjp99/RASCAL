function [ handles ] = RASCAL_DisplaySetupTraces( handles )
%RASCAL_TEST_DISPLAYSETUP Summary of this function goes here
%   Detailed explanation goes here

%% Set Trace Plots
% Trace3 Plot Overlay
handles.Trace3Plot.Position=[0.03, 0.635,0.57, 0.33];
handles.Trace3 = scatter(0, 0, 3,[0.2,0.2,0.8],'+','Parent',handles.Trace3Plot);
handles.Trace3Plot.XColor=([0.2,0.2,0.8]);
handles.Trace3Plot.YColor=([0.2,0.2,0.8]);
handles.Trace3Plot.Color=('none');
handles.Trace3Plot.YAxisLocation=('right');
handles.Trace3Plot.YLabel.String=('n/a');
handles.Trace3Plot.PlotBoxAspectRatioMode='auto';
setAllowAxesZoom(zoom,handles.Trace3Plot,true);
setAxesZoomMotion(zoom,handles.Trace3Plot,'horizontal');
hold(handles.Trace3Plot,'on');
handles.Trace3Plot.Tag='Trace3Plot';
% Trace 1 Plot Superimposed
handles.Trace1 = scatter(0,0,3, [0.8,0.2,0.2],'x', 'Parent',handles.Trace1Plot);
handles.Trace1Plot.Position=get(handles.Trace3Plot,'Position');
handles.Trace1Plot.Color=('none');
handles.Trace1Plot.XTick=[];
handles.Trace1Plot.XTickLabel=[];
handles.Trace1.Parent.XLim=[0,1];
handles.Trace1Plot.PlotBoxAspectRatioMode='auto';
setAllowAxesZoom(zoom,handles.Trace1Plot,true);
setAxesZoomMotion(zoom,handles.Trace1Plot,'horizontal');
hold(handles.Trace1Plot,'on');
handles.Trace1Plot.Tag='Trace1Plot';

% % Trace 2 Plot Superimposed
handles.Trace2 = scatter(0,0,3,[0.8,0.2,0.2],'o', 'Parent',handles.Trace2Plot);
handles.Trace2Plot.Position=get(handles.Trace3Plot,'Position');
handles.Trace2Plot.Color=('none');
handles.Trace2Plot.XTick=[];
handles.Trace2Plot.XTickLabel=[];
handles.Trace2.Parent.XLim=[0,1];
handles.Trace2Plot.PlotBoxAspectRatioMode='auto';
handles.Trace2Plot.TickDir='out';
setAllowAxesZoom(zoom,handles.Trace2Plot,true);
setAxesZoomMotion(zoom,handles.Trace2Plot,'horizontal');
hold(handles.Trace2Plot,'on');
handles.Trace2Plot.Tag='Trace2Plot';

%% set up trace plot buttons and pop up menu positions
% Set Pop Up Selections
DataNames=getappdata(handles.DataGUI,'DataNames');
set(handles.ClusterX1,'String',DataNames)
set(handles.ClusterY1,'String',DataNames)
set(handles.ClusterX2,'String',DataNames)
set(handles.ClusterY2,'String',DataNames)
set(handles.popTrace1,'String',DataNames)
set(handles.popTrace2,'String',DataNames)
set(handles.popTrace3,'String',DataNames)
handles.Trace1Chem='-';
handles.Trace2Chem='-';
handles.Trace3Chem='-';
handles.TraceX='TC';
handles.SelectCluster=[0,0];

%% Trace Button Positions
handles.popTrace2.Position(1,1)=handles.Trace3Plot.Position(1,1)+handles.Trace3Plot.Position(1,3)/2-handles.popTrace1.Position(1,3)/2; % centre of trace plot
handles.popTrace2.Position(1,2)=handles.Trace3Plot.Position(1,2)+handles.Trace1Plot.Position(1,4)+0.002; % level with trace1 menu
handles.trace2txt.Position(1,1)=handles.popTrace2.Position(1,1); % in line with menu
handles.trace2txt.Position(1,2)=handles.popTrace2.Position(1,2)+handles.popTrace2.Position(1,4)/2; % offset above menu

handles.popTrace1.Position(1,1)=handles.popTrace2.Position(1,1)-handles.popTrace1.Position(1,3)-0.002; % offset left of trace 2 pop
handles.popTrace1.Position(1,2)=handles.popTrace2.Position(1,2); % top of trace plot
handles.trace1txt.Position(1,1)=handles.popTrace1.Position(1,1); % in line with menu
handles.trace1txt.Position(1,2)=handles.popTrace1.Position(1,2)+handles.popTrace1.Position(1,4)/2; % offset above menu

handles.popTrace3.Position(1,1)=handles.popTrace2.Position(1,1)+handles.popTrace2.Position(1,3)+0.002; % slight offset to right of trace2 menu
handles.popTrace3.Position(1,2)=handles.popTrace2.Position(1,2); % level with trace1 menu
handles.trace3txt.Position(1,1)=handles.popTrace3.Position(1,1); % in line with menu
handles.trace3txt.Position(1,2)=handles.popTrace3.Position(1,2)+handles.popTrace3.Position(1,4)/2; % offset above menu

handles.ZoomAll.Position(1,1)=handles.Trace3Plot.Position(1,1)+0.002; % left align trace plot
handles.ZoomAll.Position(1,2)=handles.Trace3Plot.Position(1,2)+handles.Trace3Plot.Position(1,4)+0.002; % above trace plot


end

