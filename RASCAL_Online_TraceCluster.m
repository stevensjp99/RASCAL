function [handles] = RASCAL_Online_TraceCluster( handles )
%RASCAL_ONLINE_TRACECLUSTER Summary of this function goes here
%   Updates cluster plot for trace chemistry.
% Inputs:
% handles: handles to all current objects
% Ouputs:
% handles
% Last modified: R Hyde 21/10/16

% DataIn=[handles.Trace1.YData(end),handles.Trace2.YData(end)]; % get last data sample from trace plots
DataIn=getappdata(handles.DataGUI,'RunningData');
DataIn=DataIn(end,[handles.popTrace1.Value,handles.popTrace2.Value]);
if ~any(DataIn==0) & ~any(isnan(DataIn)) % do not cluster if no non-zero values or data contains NaN
    %% normalise data for clustering based on expected range data provided
    DataScale=getappdata(handles.DataGUI, 'DataLimits'); % get all data scales
    DataScale=DataScale(:,[handles.popTrace1.Value,handles.popTrace2.Value]); % relevant data scales
%     DataIn=(DataIn-DataScale(1,:))./ (DataScale(2,:)-DataScale(1,:));

%%
    CEDASRadius=getappdata(handles.DataGUI,'CEDASRadius');
    CEDASDecay=getappdata(handles.DataGUI,'CEDASDecay');
    CEDASMinThreshold=getappdata(handles.DataGUI, 'CEDASMinThreshold');
    AlphaHullParams=getappdata(handles.DataGUI,'AlphaHullParams');
    ColourList=getappdata(handles.DataGUI,'ColourList');
    [handles.ClustersOnLine1]=RASCAL_Online_CEDAS(CEDASRadius, CEDASMinThreshold, CEDASDecay, DataIn, handles.ClustersOnLine1);
  
    %%
    [ClusterAlpha, NumberOfHulls]=RASCAL_Online_AlphaHulls_01(handles.ClustersOnLine1, AlphaHullParams, handles); % create alpha hulls by group
    cla(handles.Cluster1);
    for idx=1:NumberOfHulls
        [F,V]=alphaTriangulation(ClusterAlpha.(strcat('Group',num2str(idx))));
        if size(V,1)>0
            %scale alpha hull back to original data size
%             V=(V.*repmat(DataScale(2,:),size(V,1),1))+repmat(DataScale(1,:),size(V,1),1);
            hp=patch(V(:,1),V(:,2), ColourList(idx,:), 'FaceAlpha', AlphaHullParams(4), 'LineStyle', 'none','Parent',handles.Cluster1);
            hp.Faces=F;
        end
    end
    
end
DataNames=getappdata(handles.DataGUI,'DataNames');
handles.Cluster1.XLabel.String=DataNames(handles.popTrace1.Value);
handles.Cluster1.YLabel.String=DataNames(handles.popTrace2.Value);
end % end function


