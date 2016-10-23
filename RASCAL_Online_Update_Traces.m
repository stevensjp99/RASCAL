function [handles] = RASCAL_Online_Update_Traces( handles )
%RASCAL_ONLINE_UPDATE_TRACES Summary of this function goes here
%   Detailed explanation goes here

%% read data
TraceInfo=[handles.popTrace1.Value,handles.popTrace2.Value,handles.popTrace3.Value];
if any(TraceInfo>1) % don't waste time plotting if no trace data selected
    TraceData=getappdata(handles.DataGUI,'RunningData');
    TraceColours=getappdata(handles.DataGUI,'TraceColours');
    XLimExt=50; % empty paddding at end of display for data
    MinXLims=500; % minimum length of display
%     ML=0; % amount to shift display if required
    ZoomFlag=[]; % is display zoomed?
    
    TraceXData=TraceData(:,handles.TC);
    TraceYData=TraceData(:,TraceInfo);

    %% set plot trace data
%     RASCAL_Online_UpdateTraceColours(handles);
        %% set line colours and pop up menu background 
    if size(unique(TraceColours,'rows'),1)==1 % if no groups coloured
        % set default line colours
        set(handles.Trace1,'XData',TraceXData,...
            'YData',TraceYData(:,1),...
            'CData',[1,0,0]);
        set(handles.Trace2,'XData',TraceXData,...
            'YData',TraceYData(:,2),...
            'CData',[0,1,0]);
        set(handles.Trace3,'XData',TraceXData,...
            'YData',TraceYData(:,3),...
            'CData',[0,0,1]);
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
        set(handles.Trace1,'XData',TraceXData,...
            'YData',TraceYData(:,1),...
            'CData',TraceColours);
        set(handles.Trace2,'XData',TraceXData,...
            'YData',TraceYData(:,2),...
            'CData',TraceColours);
        set(handles.Trace3,'XData',TraceXData,...
            'YData',TraceYData(:,3),...
            'CData',TraceColours);
        % clear popup menu backgrounds
        handles.popTrace1.BackgroundColor=[1,1,1];
        handles.popTrace2.BackgroundColor=[1,1,1];
        handles.popTrace3.BackgroundColor=[1,1,1];
    end

    %% Check if zoomed and / or set to data limits
    if size(TraceData,1)>MinXLims
        CurrentXLims=handles.Trace3Plot.XLim;
        % never display before data start
        if CurrentXLims(1)<=TraceData(1,handles.TC) % if zoomed such that display start before data
            NewXLims(1)=TraceData(1,handles.TC); % set display to data start
        else
            NewXLims(1)=CurrentXLims(1);
        end
        % check zoom
        if CurrentXLims(2)<handles.Trace3.XData(end)-1 % if XLims < Data limit -1 then must be zoomed
            ZoomFlag=1; % view is zoomed
            NewXLims(2)=CurrentXLims(2);
        else
            ZoomFlag=0; % view is not zoomed
            if CurrentXLims(2)==handles.Trace3.XData(end)-1 % if data at end of trace
                NewXLims(2)=handles.Trace3.XData(end)+XLimExt; % extend trace
            else
                NewXLims(2)=CurrentXLims(2); % no change
            end
        end

        % Minimum display view
        if NewXLims(2)-NewXLims(1)<MinXLims % if less than minimum display
            NewXLims(2)=NewXLims(1)+MinXLims; % increase display length
        end
        % Not Zoomed out too far
        if NewXLims(2)>handles.Trace3.XData(end)+XLimExt % check display sensible
                ML=NewXLims(2)-(handles.Trace3.XData(end)+XLimExt); % move display left if necessary
                NewXLims(2)=NewXLims(2)-ML;
%                 NewXLims(1)=NewXLims(1)-ML;
        end
    else
        NewXLims=[TraceData(1,handles.TC),TraceData(1,handles.TC)+MinXLims];
    end

    handles.Trace1Plot.XLim=NewXLims;
    handles.Trace2Plot.XLim=handles.Trace1Plot.XLim;
    handles.Trace3Plot.XLim=handles.Trace1Plot.XLim;

    %% set Ylims with error check if not zoomed
    if ZoomFlag==0;
        if any(isnan([min(handles.Trace1.YData)-1,max(handles.Trace1.YData)+1]))
            handles.Trace1Plot.YLim=[0,1]; % set default
        else
            handles.Trace1Plot.YLim=[min(handles.Trace1.YData)-1,max(handles.Trace1.YData)+1];
        end
        if any(isnan([min(handles.Trace2.YData)-1,max(handles.Trace2.YData)+1]))
            handles.Trace2Plot.YLim=[0,1]; % set default
        else
            handles.Trace2Plot.YLim=[min(handles.Trace2.YData)-1,max(handles.Trace2.YData)+1];
        end
        if any(isnan([min(handles.Trace3.YData)-1,max(handles.Trace3.YData)+1]))
            handles.Trace3Plot.YLim=[0,1]; % set default
        else
            handles.Trace3Plot.YLim=[min(handles.Trace3.YData)-1,max(handles.Trace3.YData)+1];
        end
    end

end

end

