function [ handles ] = RASCAL_DisplaySetupClusterPlots( handles )
%RASCAL_DISPLAYSETUPCLUSTERPLOTS Summary of this function goes here
%   Detailed explanation goes here

handles.uipanelTraceClusters.Position=[0.015, 0.014, 0.31, 0.54];
handles.uipanelSelect1.Position= handles.uipanelTraceClusters.Position+[ 0.32, 0, 0, 0];
handles.uipanelSelect2.Position= handles.uipanelSelect1.Position+[ 0.32, 0, 0, 0];
handles.Cluster1.Position=[0.082, 0.03, 0.85,0.97];
handles.Cluster2.Position=handles.Cluster1.Position;
handles.Cluster3.Position=handles.Cluster1.Position;

%% Cluster Plot Control Positions
handles.ClusterX1.Position=[0.082,0.93,0.35,0.05];
handles.textSelectX1.Position=handles.ClusterX1.Position+[0,0.025,0,0];
handles.ClusterY1.Position=handles.ClusterX1.Position+[0.36,0,0,0];
handles.textSelectY1.Position=handles.ClusterY1.Position+[0,0.025,0,0];
handles.UpdateSelected1.Position=handles.ClusterY1.Position+[0.36,0.012,-0.22,-0.01];

handles.ClusterX2.Position=[0.082,0.93,0.35,0.05];
handles.textSelectX2.Position=handles.ClusterX2.Position+[0,0.025,0,0];
handles.ClusterY2.Position=handles.ClusterX2.Position+[0.36,0,0,0];
handles.textSelectY2.Position=handles.ClusterY2.Position+[0,0.025,0,0];
handles.UpdateSelected2.Position=handles.ClusterY2.Position+[0.36,0.012,-0.22,-0.01];


end

