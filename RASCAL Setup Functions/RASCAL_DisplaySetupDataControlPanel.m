function [ handles ] = RASCAL_DisplaySetupDataControlPanel( handles )
%RASCAL_DISPLAYSETUPDATACONTROLPANEL Summary of this function goes here
%   Detailed explanation goes here

handles.uipanelData.Position=[0.34, 0.56, 0.3, 0.05];
handles.SelectData.Position=[handles.uipanelData.Position(1,1)-handles.uipanelData.Position(1,3)-0.05,...
    handles.uipanelData.Position(1,2), 0.1, 0.49]; % top of panelhandles.ClearGroupBtn.Position(1,1)=handles.SelectData.Position(1,1); % level with select button
handles.ClearGroupBtn.Position=handles.SelectData.Position-[0, 0.52, 0 0];; % level with select button

end

