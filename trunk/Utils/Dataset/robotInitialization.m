
function R=robotInitialization(Data)

% read data from file
[vertices, edges, edges_introb]=loadMultirobotDataSet(Data.name,Data.saveFiles);
[Data.vert, Data.ed, Data.edIntRob]=cut2maxIDMultirobot(Data.maxID, vertices, edges, edges_introb);

% size graph
Data.nEd=size(Data.ed,1);
Data.nEdIntRob=size(Data.edIntRob,1);
Data.nVert=size(Data.vert,1);
% TODO get this from data
Data.obsType='rb'; % range and bering

% %Config
Config=initConfig(Data);

%System
System.type='Jacobian';
System.ndx=1:Config.PoseDim;
R0=chol(inv(Config.s0));
System.A(System.ndx,System.ndx)=sparse(R0); % Given noise in the 1st pose
System.b(System.ndx,1)=zeros(Config.PoseDim,1); % the pose will not be updated

%Graph
Graph.F=[]; % keeps the factors
%variables
Graph.idX=Data.vert(1,1); % the id in the variables in the graph
Graph.Matrix=sparse(zeros(Data.nVert,Data.nVert));


R.Data=Data;
clear Data;
R.Config=Config;
clear Config;
R.System=System;
clear System;
R.Graph=Graph;
clear Graph

