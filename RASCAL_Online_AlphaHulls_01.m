function [ClusterAlpha,HullNumber]=RASCAL_Online_AlphaHulls_01(ClustersOnLine1, AlphaHullParameters, handles)

% RASCAL_Online_AlphaHulls_01 creates alpha hulls of offline clustering results
% Inputs:
% GroupNumber: number of groups selected
% ClustersOnline1: results of online clustering, cluster centres and
%               quadrant co-ordinates
% AlphaHulParameters: all parameters for alpha hulls, values are fixed
%               during initial setup.
% Outputs:
% ClusterAlpha: structure containg all the alpha hulls for each group
% HullNumber: the number of alpha hulls created
% Last modified: R Hyde 24/02/15


HullNumber=1;
for idx=1:max(ClustersOnLine1.global);
    
    ClusterCentre=ClustersOnLine1.Centre(ClustersOnLine1.global==idx,:);
    ClusterRadius=getappdata(handles.DataGUI, 'CEDASRadius');
    if size(ClusterCentre,1)>0;
    XVals=[ClusterCentre(:,1)-ClusterRadius(:,1),ClusterCentre(:,2) ; ClusterCentre(:,1)+ClusterRadius(:,1),ClusterCentre(:,2)];
    YVals=[ClusterCentre(:,1),ClusterCentre(:,2)-ClusterRadius(:,1) ; ClusterCentre(:,1),ClusterCentre(:,2)+ClusterRadius(:,1)];
    ClusterPatch=[ClusterCentre;XVals;YVals];
    ClusterPatch=unique(ClusterPatch,'rows');
    ClusterAlpha.(strcat('Group',num2str(HullNumber))) = alphaShape(ClusterPatch,AlphaHullParameters(1),...
        'HoleThreshold',AlphaHullParameters(2),...
        'RegionThreshold',AlphaHullParameters(3));
    HullNumber=HullNumber+1;
    end
end

if exist('ClusterAlpha') % if cluster hulls have been created do nothing, else add empty variable
else
    ClusterAlpha=struct;
end
HullNumber=HullNumber-1;
end % end main function