function [ ] = RASCAL_Online_ChangeTraces( handles )
%RASCAL_ONLINE_CHANGETACES Summary of this function goes here
%   Detailed explanation goes here
Data=getappdata(handles.DataGUI,'RunningData');
if size(Data,1)>0
    set(handles.Trace1,'XData',Data(:,handles.TC),'YData',Data(:,handles.popTrace1.Value));
    set(handles.Trace2,'XData',Data(:,handles.TC),'YData',Data(:,handles.popTrace2.Value));
    set(handles.Trace3,'XData',Data(:,handles.TC),'YData',Data(:,handles.popTrace3.Value));
    guidata(handles.DataGUI,handles) % update GUI data
end
end

