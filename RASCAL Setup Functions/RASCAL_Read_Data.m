function [DataIn, DataNames, DataLimits, FireFile]=RASCAL_Read_Data()

% RASCAL_Offline_Read_Data read data from a csv file into a table
%
% Reads data from file selected in GUI. Corrects invalid data names and
% replaces some error codes with 'NaN'. Assembles all data into a table.
% Inputs: none
%
% Outputs: 
% DataIn: Table of data read from file
% DataNames: Alphabetical list of data names
%
% Last Modified: R Hyde 26/03/15
% PathName=getenv('userprofile');
% PathName=('');
PathName=('C:\Users\hyder\Documents\Qsync\Matlab\R Hyde\Multi Analysis\RASCAL\RASCAL Online\Data');
% [FileName,PathName] = uigetfile({'*.csv';'*.*'},'Select Data File',PathName); % select data file of climate instrument outputs
FileName=('B735_All_Model_Interp.csv'); % default during testing
DataIn=readtable(fullfile(PathName,FileName)); % read data to table
[~, idx]=sort(upper(DataIn.Properties.VariableNames)); % find alphabetical order index of data name
DataIn=DataIn(:,idx); % sort data table into alphabetical order
DataNames=[DataIn.Properties.VariableNames]; % read data names
DataNames=[{'-'},DataNames];
DataNames=strrep(DataNames, '_','-'); % change '_' to '-' for clear display
DataIn=standardizeMissing(DataIn,{-9999}); % replace error codes with NaN
DataIn=[array2table(zeros(size(DataIn,1),1),'VariableNames',{'null'}),DataIn]; % prepend null column for non-selected values

%% Load Data Limits
% DataLimits=csvread(fullfile(PathName,'DataLimits.csv'),1,0); % Use for
% streaming, expected min/max values
DataLimits=[min(table2array(DataIn),[],1);max(table2array(DataIn),[],1)]; % use for data read max and min from file

%% Load Fire Data
% PathNameFire=fullfile(PathName,'\Firms\Month');
% if exist(PathNameFire,'file')==7
%     FireFile=dir(fullfile(PathNameFire,'\*.shp'));
%     FireFile=fullfile(PathNameFire,FireFile.name);
% 
% end

%% Load Fire Data
PathNameFire=fullfile(PathName,'\Firms');
if exist(PathNameFire,'file')==7
%     [FileName,PathName] = uigetfile({'*.shp';'*.*'},'Select Fire Data File',PathNameFire); % select data file of climate instrument outputs
    FireFile=dir(fullfile(PathName,FileName));
    FireFile=fullfile(PathName,FireFile.name);
    FireFile=fullfile(PathNameFire,'firms222141432057501_MCD14ML.shp'); % default during testing
%      FireFile=dir(fullfile(PathNameFire,'\*.shp'));
%     FireFile=fullfile(PathNameFire,FireFile.name);
end
