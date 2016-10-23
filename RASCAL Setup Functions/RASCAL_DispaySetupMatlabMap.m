function [ handles ] = RASCAL_DispaySetupMatlabMap( handles )
%RASCAL_DISPAYSETUPMATLABMAP Summary of this function goes here
%   Detailed explanation goes here

latlim=[-20 -0];
lonlim=[-70 -50];
axes(handles.AxesMap);
[handles.MapPlot]=worldmap(latlim, lonlim);
handles.MapPlot.Position=[0.4000 0.5500 0.7750 0.40];
land = shaperead('landareas', 'UseGeoCoords', true);
geoshow(handles.MapPlot, land, 'FaceColor', [0.8 0.9 0.8])
lakes = shaperead('worldlakes', 'UseGeoCoords', true);
geoshow(lakes, 'FaceColor', 'blue')
rivers = shaperead('worldrivers', 'UseGeoCoords', true);
geoshow(rivers, 'Color', 'blue')
cities = shaperead('worldcities', 'UseGeoCoords', true);
geoshow(cities, 'Marker', '.', 'Color', 'red')

handles.MapPlot.DataAspectRatioMode='auto';
handles.MapPlot.Position=[0.65 0.6 0.3 0.35];
handles.FlightPath=geoshow(handles.MapPlot,latlim,lonlim,'Tag','Flight');
handles.FlightPath.XData=[];
handles.FlightPath.YData=[];

end

