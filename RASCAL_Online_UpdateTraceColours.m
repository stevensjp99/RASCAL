function [ ] = RASCAL_Online_UpdateTraceColours( handles )
%RASCAL_ONLINE_UPDATETRACECOLOURS Summary of this function goes here
%   Detailed explanation goes here

TraceColours=getappdata(handles.DataGUI,'TraceColours');
    TraceColours=TraceColours(1:handles.DataEvent,:);

if size(unique(TraceColours,'rows'),1)==1 % if no groups coloured
    % set default line colours
    set(handles.Trace1,'CData',[1,0,0]);
    set(handles.Trace2,'CData',[0,1,0]);
    set(handles.Trace3,'CData',[0,0,1]);
    % Set axis colours
    handles.Trace1Plot.YColor=[1,0,0];
    handles.Trace2Plot.YColor=[0,1,0];
    handles.Trace3Plot.YColor=[0,0,1];
    % set popup menu backgrounds
    handles.popTrace1.BackgroundColor=[1,0.4,0.4];
    handles.popTrace2.BackgroundColor=[0.4,1,0.4];
    handles.popTrace3.BackgroundColor=[0.4,0.4,1];
else
    % set grouped line colours
    set(handles.Trace1,'CData',TraceColours);
    set(handles.Trace2,'CData',TraceColours);
    set(handles.Trace3,'CData',TraceColours);
    % clear popup menu backgrounds
    handles.popTrace1.BackgroundColor=[1,1,1];
    handles.popTrace2.BackgroundColor=[1,1,1];
    handles.popTrace3.BackgroundColor=[1,1,1];
end

end % end function

