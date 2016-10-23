function [ handles ] = RASCAL_Online_UpdateFlightPath( handles )
%RASCAL_ONLINE_UPDATEFLIGHTPATH Summary of this function goes here
%   Detailed explanation goes here

% NewSample=getappdata(handles.DataGUI,'NewSample');
SpatialData=getappdata(handles.DataGUI,'RunningData');
SpatialData=SpatialData(:,[handles.Lat,handles.Lon]);
TraceColours=getappdata(handles.DataGUI,'TraceColours');

if size(unique(TraceColours,'rows'),1)==1 
    set(handles.FlightPlot1,'XData',SpatialData(:,2),...
        'YData',SpatialData(:,1),...
        'CData',[0.4, 0.4, 0.4] );
else
    set(handles.FlightPlot1,'XData',SpatialData(:,2),...
        'YData',SpatialData(:,1),...
        'CData',TraceColours);
end
guidata(handles.DataGUI,handles) % update GUI data

end

