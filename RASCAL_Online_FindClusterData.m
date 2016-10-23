function [] = RASCAL_Online_FindClusterData( varargin )
%RASCAL_OFFLINE_FINDCLUSTERDATA Summary of this function goes here
%   Detailed explanation goes here

handles=varargin{1};
SelectShape=varargin{2};
DataSelection=varargin{3};
TraceColours=getappdata(handles.DataGUI,'TraceColours');
% TraceColours=TraceColours(1:handles.DataEvent,:);
ColourList=getappdata(handles.DataGUI,'ColourList');
NumGroups=size(unique(TraceColours,'rows'),1);

% DataIn=getappdata(handles.DataGUI,'DataIn');
DataTest=getappdata(handles.DataGUI,'RunningData');
DataTest=DataTest(:,DataSelection);
% DataTest=table2array(DataIn(:,DataSelection));
Selected=find(inpolygon(DataTest(:,1),DataTest(:,2),SelectShape(:,1),SelectShape(:,2)));

TraceColours([Selected],:)=repmat(ColourList(NumGroups+1,:),size(Selected,1),1);
[~,~,Groups]=unique(TraceColours,'rows');

setappdata(handles.DataGUI,'TraceColours',TraceColours);
setappdata(handles.DataGUI,'Groups',Groups);

end

