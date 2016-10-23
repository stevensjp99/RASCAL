function [ handles ] = RASCAL_DisplaySetupGoogleMap( handles, lat, lon )
%RASCAL_DISPLAYSETUPMAP Summary of this function goes here
%   Detailed explanation goes here
DataIn=getappdata(handles.DataGUI,'DataIn');
lat=[min(DataIn.LAT_GPS),max(DataIn.LAT_GPS)];
lon=[min(DataIn.LON_GPS),max(DataIn.LON_GPS)];

handles.AxesMap.Position=[0.655, 0.635,0.257, 0.3375];
plot(handles.AxesMap,lon,lat,'.r','MarkerSize',10);
RASCAL_Online_plot_google_map('Axis', handles.AxesMap,'MapType','terrain')
handles.AxesMap.Tag='MapPlot';
delete(findobj(handles.AxesMap.Children,'Type','Line'));
handles.FlightPlot1=scatter(handles.AxesMap,-60,-10);
set(handles.FlightPlot1,'XData',[],'YData',[],'CData',[],...
    'Marker','+','MarkerFaceAlpha',0.5,'SizeData',10,'Tag','FlightPlot');
zoom(handles.AxesMap,'on')
handles.PanelOverlay.Position=[handles.AxesMap.Position(1,1)+...
    handles.AxesMap.Position(1,3),handles.AxesMap.Position(1,2),0.05,0.34];
end

