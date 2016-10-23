function [Clusters]=RASCAL_Online_DDC_Off(DataIn, Groups, DataColumns, InitialRadius)
% R Hyde DDC offline Clustering
% Function created for use with RASCAL Climate Analysis
% Inputs:
%   DataIn: All the  current data
%   GroupList: The start, end point of each selected data group
%   DataColumns: List of the data columns to be clustered
%   InitialRadius: Initial radius of cluster for DDC routine
% Outputs:
%   Clusters: Structure containing the cluster centres and radii for each
%   data group.
% All the clusters for a group are later used in RASCAL to create alpha
% hulls enclosing the cluster centres and quadrant points. Alternatively
% they could be used to draw the cluster shapes coloured by cluster but the
% output is less clear.
%
% Last update 22/03/15

%% Get data for each group

% for GroupNumber=1:size(GroupList,1)-1; % set group number (do in loop eventually)
for GroupNumber=1:size(unique(Groups),1)
%  GroupNumber=4;   
ClusterCentre=[];
ClusterRadius=[];
Data4Cluster=DataIn(Groups==GroupNumber,:);
Data4Cluster(any(isnan(Data4Cluster),2),:)=[]; % remove any row with NaN
Data4Cluster(any(Data4Cluster==0,2),:) = []; % remove rows with any zeros

%% Do the following for each data group
ClusterNumber=0; % number of current cluster being created
% InitialRadius=0.2; % set initial radius for circular sub-cluster
SubClusters=[];

GlobalMean=nanmean(Data4Cluster,1); % array of means of data dims
GlobalScalar=sum(sum((Data4Cluster.*Data4Cluster),2),1)/size(Data4Cluster,1); % array of scalar products of data dims

while size (Data4Cluster,1)>0
    ClusterNumber=ClusterNumber+1;
    %% Find densest point & assign as cluster centre
    DensityArray=1./(1+(pdist2(Data4Cluster,GlobalMean,'euclidean').^2)+GlobalScalar-(sum(GlobalMean.^2))); % calculate global densities
    [~, idx]=max(DensityArray); % find index of max densest point
    ClusterCentre(ClusterNumber,:)=Data4Cluster(idx,:); % assign cluster centre
%     Data4Cluster(idx,:)=[]; % remove from available data
    
    %% find all sample in cluster radius
    DistanceArray=pdist2(ClusterCentre(ClusterNumber,:),Data4Cluster);
    [~,idx]=find(DistanceArray<InitialRadius);
    ClusterTmp=Data4Cluster(idx,:); % temporary cluster array
    
    %% Remove outliers
    LocalDistance=pdist2(ClusterTmp,ClusterCentre(ClusterNumber,:));
    idx = abs(LocalDistance - mean(LocalDistance) > 3*std(LocalDistance));
    idx=find(idx>1); % >3sigma distance
    Data4Cluster=[Data4Cluster;ClusterTmp(idx,:)]; % return outliers to data
    ClusterTmp(idx,:)=[];% remove outliers from temporary cluster
    
    %% Adjust Radius
    LocalDistance(idx)=[]; % remove distance measures of outliers
    ClusterRadius(ClusterNumber,:)=max(LocalDistance);
    
    %% Move Cluster Centre to Local Densest Point
    LocalMean=mean(ClusterTmp,1);
    LocalScalar=sum(sum((ClusterTmp.*ClusterTmp),2),1)/size(ClusterTmp,1);
    LocalDensityArray=1./(1+(pdist2(ClusterTmp,LocalMean,'euclidean').^2)+LocalScalar-(sum(LocalMean.^2)));
    [~,idx]=max(LocalDensityArray);
    ClusterCentre(ClusterNumber,:)=ClusterTmp(idx,:); % assign densest point to cluster centre
    ClusterTmp(idx,:)=[]; % remove centre from cluster data
    
    %% Reassign data to new cluster centre
%     Data4Cluster=[Data4Cluster;ClusterTmp]; % return temporary clustered data
    DistanceArray=pdist2(Data4Cluster,ClusterCentre(ClusterNumber,:));
    [idx,~]=find(DistanceArray<=ClusterRadius(ClusterNumber,:)); % find samples within adjusted radius
    ClusterTmp=Data4Cluster(idx,:);
    Data4Cluster(idx,:)=[]; % remove from data
%     ClusterTmp=[Data4Cluster(idx,:);ClusterCentre(ClusterNumber,:)]; % include cluster centre
    ClusterTmp=[ClusterTmp, ones(size(ClusterTmp,1),1)*ClusterNumber]; % append sub-cluster number
    SubClusters=[SubClusters;ClusterTmp];
    
    
end    

Clusters.Centres.(strcat('Group',num2str(GroupNumber)))=ClusterCentre;
Clusters.Radius.(strcat('Group',num2str(GroupNumber)))=ClusterRadius;
end

end % End main function
