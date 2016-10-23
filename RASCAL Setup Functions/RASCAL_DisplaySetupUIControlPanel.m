function [ handles ] = RASCAL_DisplaySetupUIControlPanel( handles )
%RASCAL_DISPLAYSETUPUICONTROLPANEL Summary of this function goes here
%   Detailed explanation goes here

handles.uicontrolpnl.Position=[0.1, 0.56, 0.3, 0.05];
handles.uicontrolpnl.Position=[0.015, 0.56, 0.31, 0.05]; % set panel position
handles.TracePlotRefreshText.Position=[0,0.4, 0.05, 0.6]; % set plot refresh rate text box position
handles.TraceRefreshSlider.Position=[handles.TracePlotRefreshText.Position(1,3),...
    0.45, 0.028, 0.6]; % set plot refresh slider position
handles.TraceRefreshText.Position=[handles.uicontrolpnl.Position(1,1)-0.01,...
    -0.3, 0.07, 0.68]; % set plot refresh rate text position

end

