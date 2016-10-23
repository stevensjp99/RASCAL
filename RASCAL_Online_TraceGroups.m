function [] = RASCAL_Online_TraceGroups( varargin )
%RASCAL_OFFLINE_TRACEGROUPS_VER01 Summary of this function goes here
%   Detailed explanation goes here

handles=varargin{1};
NewPoint=varargin{2};
ColourList=getappdata(handles.DataGUI,'ColourList');
TraceColours=getappdata(handles.DataGUI,'TraceColours');
[~,GroupLimits,~]=unique(TraceColours,'rows'); % find current group limits
GroupLimits=[GroupLimits;size(TraceColours,1)];

%% Add new point
if strcmp(handles.MouseClick,'normal')
    GroupLimits=sort([GroupLimits;NewPoint]); % append new limit and sort
    
%% Remove nearest point
elseif strcmp(handles.MouseClick,'alt')
    [~,idx]=min(abs(GroupLimits-(NewPoint))); % find index nearest point
    GroupLimits(idx)=[];
    GroupLimits=sort(GroupLimits);
end
%% Update list
if size(GroupLimits,1)>1
    for idx=1:size(GroupLimits,1)-1
        clr=rem(idx,size(ColourList,1));
        TraceColours(GroupLimits(idx):GroupLimits(idx+1),:)=repmat(ColourList(clr,:),[GroupLimits(idx+1)-GroupLimits(idx)+1,1]);
    end
    TraceColours(end,:)=TraceColours(end-1,:);
else
    TraceColours=repmat([0],size(TraceColours));
end
setappdata(handles.DataGUI,'TraceColours',TraceColours);
end

