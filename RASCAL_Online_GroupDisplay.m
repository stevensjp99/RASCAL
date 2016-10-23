function [] = RASCAL_Online_GroupDisplay( varargin )
%RASCAL_ONLINE_FLIGHT Summary of this function goes here
%   Detailed explanation goes here

handles=varargin{1};
ClusterPlot=varargin{2};

%Update Cluster Plot
RASCAL_Online_ClusterPlots(handles, ClusterPlot);
% RASCAL_Online_Update_Traces(handles);

TraceColours=getappdata(handles.DataGUI,'TraceColours');
TraceColours=TraceColours(1:handles.DataEvent,:);
if size(handles.Trace1.XData,1)>1
set(handles.Trace1,'CData',TraceColours);
end
if size(handles.Trace2.XData,1)>1
set(handles.Trace2,'CData',TraceColours);
end
if size(handles.Trace3.XData,1)>1
set(handles.Trace3,'CData',TraceColours);
end
if size(handles.FlightPlot1.XData,1)>1
set(handles.FlightPlot1,'CData',TraceColours); % update flight plot
end

guidata(handles.DataGUI,handles) % update GUI data
end

