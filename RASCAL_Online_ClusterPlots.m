function [] = RASCAL_Online_ClusterPlots( varargin )
%RASCAL_OFFLINE_TRACECLUSTER Summary of this function goes here
%   Detailed explanation goes here
%   If update button for cluster plot 2 is pressed this routine updates the
%   plot of the alpha hulls and colours for each group using DDC offline clustering.
%
% Inputs:
% handles: handles to all current objects
% DataIn: All data
% GroupList: list of start and end indices for selected data groups
% ClusterPair: index of the monitored chemistry in the data list
% DDCInitialRadius: Initial radius for DDC function
% AlphaHullParameters: parameters for alpha hull function
% ColourList: list of colour indices for each data group
%
% Ouputs:
% none required, all handles updated in function
%
% Last modified: R Hyde 05/09/15
handles=varargin{1};
PlotFig=varargin{2};
DataIn=getappdata(handles.DataGUI,'RunningData');
NumSamples=handles.DataEvent;
TraceColours=getappdata(handles.DataGUI,'TraceColours');
DDCInitialRadius=getappdata(handles.DataGUI,'DDCInitialRadius');
% DataNames=getappdata(handles.DataGUI,'DataNames');
% ColourList=getappdata(handles.DataGUI,'ColourList');
AlphaHullParams=getappdata(handles.DataGUI,'AlphaHullParams');

switch PlotFig
    case 1
        ClusterPair=[handles.popTrace1.Value,handles.popTrace2.Value];
        PlotWindow=handles.Cluster1;

    case 2
        ClusterPair=[handles.ClusterX1.Value,handles.ClusterY1.Value];
        DataIn=DataIn(:,ClusterPair);
        PlotWindow=handles.Cluster2;
   
    case 3
        ClusterPair=[handles.ClusterX2.Value,handles.ClusterY2.Value];
        DataIn=DataIn(:,ClusterPair);
        PlotWindow=handles.Cluster3;
end % end case


[~,~,Groups]=unique(TraceColours(1:handles.DataEvent,:),'rows'); % find current group limits
Groups=Groups(1:NumSamples,:);

[ClustersOffLine1]=RASCAL_Online_DDC_Off(DataIn, Groups, [1,2], DDCInitialRadius);

NumberOfGroups=size(unique(Groups),1);
[ClusterAlpha, NumberOfHulls]=RASCAL_Online_AlphaHulls_02(NumberOfGroups, ClustersOffLine1, AlphaHullParams); % create alpha hulls by group
cla(PlotWindow);
for idx=1:NumberOfHulls
    HullColour=TraceColours(find(Groups==idx,1),:);
    [F,V]=alphaTriangulation(ClusterAlpha.(strcat('Group',num2str(idx))));
    if size(V,1)>0
    hp=patch(V(:,1),V(:,2), HullColour, 'FaceAlpha', AlphaHullParams(4), 'LineStyle', 'none','Parent',PlotWindow);
    hp.Faces=F;
    end
end

end % end function


