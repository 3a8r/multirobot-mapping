%testIncrementalOptimizationUTIAS
close all
clear Config Graph System 

% Data.name='10K';
% maxID=100;
% [vert,ed]=loadDataSet(Data.name,0);
% [vertices,edges]=cut2maxID(maxID, vert, ed);
% edges=sortrows(edges,[1,-2]); 
% Data.ed=edges;
% Data.vert=vertices;


%DATA SET
load /Users/vila/LAAS/datasets/UTIAS/robot1_50.mat
Data.name='UTIAS20';
% put together odometry and landmarks 
% add a identification number at the end of each landmark
edges=[edges1_odo;edges1_land];
% sort on the second id to have the measurements in incremental order
Data.ed=sortrows(edges,[2,-1]);
Data.vert=[vertices1_odo;vertices1_land];

% UnitTestData %small data set to test the method
% Data.name='test';
% Data.ed=edges;
% Data.vert=vertices;
% PlotConfigGeneral(config_gnt,edges_gnt,id2config_gnt,3,2,'b'); hold on;

% size data
Data.nEd=size(Data.ed,1);
Data.nVert=size(Data.vert,1);

% PARAMETERS

%Solver
Solver.maxIT=100;
Solver.tol=1e-4;
Solver.linearSolver='spqr';
Solver.nonlinearSolver='GaussNewton';

%Plot
%flags
Plot.plotConfig=1;
Plot.plotError=0;
Plot.plotDMV=0;
Plot.spyMat=0;

%params 
Plot.faxis='off';
Plot.colour=[0.5,0.5,0.5];
Plot.nodes=0;
Plot.ftitle=Data.name;
Plot.fname=sprintf('%s_',Data.name);


%INITIALIZATION

%Config
%Constants
Config.p0 = Data.vert(1,2:end)';
Config.s0 = diag([Data.ed(1,6),Data.ed(1,8),Data.ed(1,9)]);
Config.LandDim=2;
Config.PoseDim=3;
%Variables
Config.vector=[Config.p0,[1,1,1]']; % the second column is for rapid identification of the landmark=0 vs pose=1
Config.size=size(Config.vector,1);
Config.ndx=0;
Config.nPoses=0;
Config.nLands=0;
Config.id2config=zeros(size(Data.vert,1),2);
Config.id2config(Data.vert(1,1)+1,:)=[Config.nPoses,Config.nLands];

%System
System.ndx=1:Config.PoseDim;
R0=chol(inv(Config.s0));
System.A(System.ndx,System.ndx)=sparse(R0); % Given noise in the 1st pose
System.b(System.ndx,1)=zeros(Config.PoseDim,1); % the pose will not be updated



% GRAPH

% factors 
Graph.F=[];

%variables
Graph.idX=Data.vert(1,1); % the id in the graph 


Config.dim=Config.PoseDim; %TODO change Gauss_Newton for landmarks  

ind=1;
while ind<=Data.nEd
    factorR=Data.ed(ind,:);
    [Config, System, Graph]=addFactorRobotGeneral(factorR,Config, System, Graph);
    %[Config, System]=GaussNewtonOptimizationGeneral(Config,System,Graph,Solver,Plot);
    ind=ind+1;

end

PlotConfigGeneral(Config,Graph,'r');




