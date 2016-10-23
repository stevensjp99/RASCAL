function [ handles ] = RASCAL_Online_GetDataSample( handles )
%RASCAL_ONLINE_GETDATASAMPLE Summary of this function goes here
%   Detailed explanation goes here

RunningData=getappdata(handles.DataGUI,'RunningData');
% update chemistry data
handles.DataEvent=handles.DataEvent+1;
% RunningData=[handles.RunningData;handles.FileData(handles.DataEvent,:)];
if handles.DataEvent+handles.StartOffset<size(getappdata(handles.DataGUI,'DataIn'),1) % loop without data if file ended
    NewSample=getappdata(handles.DataGUI,'DataIn');
    NewSample=table2array(NewSample(handles.DataEvent+handles.StartOffset,:));
    setappdata(handles.DataGUI,'NewSample',NewSample);
    setappdata(handles.DataGUI,'RunningData',[RunningData;NewSample]);
    TraceColours=getappdata(handles.DataGUI,'TraceColours');
    if handles.DataEvent>1
        TraceColours(end+1,:)=TraceColours(end,:);
    else
        TraceColours=[0.4 0.4 0.4];
    end
    setappdata(handles.DataGUI,'TraceColours',TraceColours); 
else 
    handles.DataEvent=handles.DataEvent-1;
end

end

