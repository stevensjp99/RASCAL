function [ ClustersOut] = RASCAL_Online_CEDAS( varargin )
%CEDAS_FUNCT 
% CEDAS cluster analysis returns cluster information when passed one data
% sequentially. Clusters will be arbitrariliy shaped groups of
% micro-clusters.
%  Use:
% ClusterParameters=[InitRad, MinClusSize,Decay];
% [Clusters]=CEDAS_Funct(ClusterParameters,Sample);
% Output:
% Clusters: structure containg all cluster information
% Clusters.Centre: centre co-ordinates of all micro-clusters
% Clusters.Count: the number of samples that have been allocated to each
%           micro-cluster
% Clusters.global: the cluster assignment of each micro-cluster
% Clusters.Life: the remaining life of each micro-cluster (0-1)
% Clusters.Parent: list of micro-cluster parents

InitRad=varargin{1};
MinClusSize=varargin{2};
Decay=varargin{3};
NewSample=varargin{4};
clusters=varargin{5};

if ~isstruct(clusters) % create empty structure
    clusters=struct();
end

ClusterChanged=0;
   if ~isempty(fieldnames(clusters))
%        NumClusts=size(clusters.Centre,1);
      
      [clusters, ClusterChanged]= CEDAS_Update_Cluster(clusters,NewSample, InitRad);
      if Decay>0 % if no decay then do not kill any micro-clusters
          [clusters]=CEDAS_Kill_Clusters(clusters, Decay); 
      end
       
      if ClusterChanged>size(clusters.Centre,1)
          ClusterChanged=0;
      end
   else % create first micro-cluster
        clusters.Centre(1,:)=NewSample;
%         clusters.Radius(1,:)=InitRad;
        clusters.Count(1,:)=1;
        clusters.global(1,:)=1;
        clusters.Life(1,:)=1; % Give cluster life to first cluster
        clusters.Parent(1,:)={1}; % create first global cluster (global clusters are -ve numbers)
    end

    if ClusterChanged~=0 && clusters.Count(ClusterChanged)>MinClusSize
%         NumClusts=size(clusters.Centre,1);
        [clusters]=CEDAS_Update_Tree(clusters,MinClusSize,ClusterChanged, InitRad);
    end
 
    ClustersOut=clusters;

function [ clusters,ClusterChanged ] = CEDAS_Update_Cluster( varargin )

%CEDAS_UPDATE_CLUSTER_01 Summary of this function goes here
%   CEDAS sub-function to update micro-cluster information and create new
%   micro-clusters
% Useage:   CEDAS_Update_Cluster_01(clusters,NewSample, InitRad);
% Inputs:
%   clusters: Structure containing the microcluster information in the fields:
%           Centre, Radius, Count, global, Life, Parent
%   NewSample: New sample of data from the data stream
%   InitRad: micro-cluster initial radius
% Outputs:
%   clusters: Structure containging micro-cluster data as above
%   ClusterChanged: numerical index of any micro-cluster that has changed

clusters=varargin{1};
NewSample=varargin{2};
InitRad=varargin{3};
NumClusts=size(clusters.Centre,1);
ClusterChanged=0;

    sqDistToAll=sum((repmat(NewSample,NumClusts,1)-clusters.Centre).^2,2); % find square distance to all centres
    DistToAll=sqrt(sqDistToAll); % find distances to all centres

    [MinDist,MinDistIdx]=min(DistToAll); % find minimum distance and index of nearest centre

    if MinDist<InitRad % if in cluster add to cluster
        ClusterChanged=MinDistIdx;
        clusters.Count(MinDistIdx)=clusters.Count(MinDistIdx)+1; % update Count of samples assigned to cluster
        clusters.Life(MinDistIdx,:)=1; % Renew cluster life to full value

        if MinDist>InitRad*0.5 % if outside cluster core
            %% adjust cluster info
            clusters.Centre(MinDistIdx,:)=((clusters.Count(MinDistIdx,:)-1)*clusters.Centre(MinDistIdx,:)+NewSample)./clusters.Count(MinDistIdx,:); % update cluster centre to mean of samples
        end

    else % create new cluster
        NumClusts=NumClusts+1; % add new cluster
        clusters.Centre(NumClusts,:)=NewSample;
%         clusters.Radius(NumClusts,:)=InitRad;
        clusters.Count(NumClusts,:)=1;
        clusters.global(NumClusts,:)=NumClusts;
        clusters.Life(NumClusts,:)=1; % give new cluster some life
        clusters.Parent{NumClusts,:}=max([clusters.Parent{:}])+1;
    end
  

function [ clusters ] = CEDAS_Kill_Clusters( varargin )
%CEDAS_KILL_CLUSTERS_01 Summary of this function goes here
%   CEDAS sub-function to decay and remove dead micro-clusters and re-assign global
%   cluster numbers to each micro-cluster.
% Use:
%   [clusters]=CEDAS_Kill_Clusters_01(clusters, Decay);
% Inputs:
% clusters: Structure containing the microcluster information in the fields:
%           Centre, Radius, Count, global, Life, Parent
% Decay: Amout to decrement the life of micro-clusters. Life is restored
%       elsewhere if the micro-cluster is re-used.
% Outputs:
%   clusters: Structure containing micro-cluster information as above.


clusters=varargin{1};
Decay=varargin{2};

if isfield(clusters,'Life')
clusters.Life=clusters.Life-(1/Decay); % Decay each cluster
Dead=find(clusters.Life<0);

    if size(Dead,1)>0;
        for idx1=1:size(Dead,1)
            %% delete cluster Dead
            for f=fieldnames(clusters)'
                clusters.(f{1})(Dead(idx1),:)=[];
            end
            %% remove all references to Dead
            if any([clusters.Parent{:}]==Dead(idx1))
            for idx2=1:size(clusters.Parent,1)
                if any(clusters.Parent{idx2}==Dead(idx1,1))
                    tmp=clusters.Parent{idx2};
                    tmp(tmp==Dead(1,1))=[];
                    clusters.Parent(idx2)={tmp};
                end
            end
            end
            %% decrement all cluster references higher than Dead
            for idx2=1:size(clusters.Parent,1)
                if any(clusters.Parent{idx2}>Dead(idx1))
                    tmp=clusters.Parent{idx2};
                    tmp(tmp>Dead(idx1))=tmp(tmp>Dead(idx1))-1;
                    clusters.Parent(idx2)={tmp};

                end
            end
        end
        %% Reassign global Number (optional, not required for relatively small datasets,...
        %% or low numbers of micro-clusters. Housekeeping to prevent ever increasing micro-cluster number)   
        clusters.global(:)=0;
        GN=0;
        while any(clusters.global==0)
            GN=GN+1;
            tmp1=0;
            tmp2=find(clusters.global==0,1,'first');
            while ~isequal(tmp1,tmp2) | isempty(tmp2)
                tmp1=tmp2;
                tmp2=unique([clusters.Parent{tmp1,:}]);
                if size(tmp2,1)==1 & tmp2(1,1)<0
                    tmp2=tmp1;
                else
                tmp2=tmp2(tmp2>0);
                end
            end
            clusters.global(tmp2)=GN;
        end

    end
end

function [ clusters, NumClusts ] = CEDAS_Update_Tree( varargin )
%CEDAS_UPDATE_TREE Summary of this function goes here
%   CEDAS sub-function to update the list of parents in the cluster tree.
% Useage: CEDAS_Update_Tree_01(clusters,MinClusSize,ClusterChanged)
% Inputs:
%   clusters: Structure containing the microcluster information in the fields:
%           Centre, Radius, Count, global, Life, Parent
%   MinClusSize: minimum number of data samples in a micro-cluster for it
%           to be valid
%   ClusterChanged: any cluster that was  created or modified with the new
%           data sample
clusters=varargin{1};
MinClusSize=varargin{2};
ClusterChanged=varargin{3};
InitRad=varargin{4};
NumClusts=size(clusters.Centre,1);

DistToAll=sqrt(sum((repmat(clusters.Centre(ClusterChanged,:),NumClusts,1)-clusters.Centre).^2,2)); % find distance to all Centres
DistToAll(clusters.Count<MinClusSize)=99; % set all small clusters to far away so not joined

Rads=InitRad*1.5; % sum the radii of changed cluster and all other clusters
[Intersect,~]=find(DistToAll<Rads); % find where cluster centres are closer than sum of radii

% if clusters.Parent{ClusterChanged}<0
%     clusters.Parent(ClusterChanged)={Intersect'};
%     clusters.global(ClusterChanged)=min(clusters.global(clusters.Parent{ClusterChanged}));
% else
clusters.Parent(ClusterChanged)={unique([clusters.Parent{ClusterChanged},Intersect'])};
GN=min(clusters.global(clusters.Parent{ClusterChanged}));
clusters.global(ClusterChanged)=GN;
clusters.global(clusters.Parent{ClusterChanged})=GN;
