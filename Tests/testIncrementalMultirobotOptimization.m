function testIncrementalMultirobotOptimization

%Data set
close all;
global Timing
Timing.flag=0;
R1.Data.name='R12D';
R1.Data.saveFiles=0;
R1.Data.maxID=0;
R2.Data.name='R12D';
R2.Data.saveFiles=0;
R2.Data.maxID=0;


%Solver
Solver.maxIT=100;
Solver.tol=1e-5;
Solver.linearSolver='spqr';
Solver.nonlinearSolver='GaussNewton';


%Plot
%flags
Plot.InitConfig=0;
Plot.Config=1;
Plot.Error=0;
Plot.DMV=0;
Plot.spyMat=0;
Plot.measurement=1;


%params 
Plot.faxis='off';
Plot.colour=[0.5,0.5,0.5];
Plot.ftitle=R1.Data.name;
Plot.fname=sprintf('%s_',R1.Data.name);

%ROBOT1
R1=robotInitialization(R1.Data);

% Randevous parrameters
R1.idXR1=R1.Data.vert(1,1);
R1.idXR2=[];
%... For each robot in the team we have a R1.idXRi=[];
R1.rendezOffset=zeros(size(R1.Data.vert,1),1);

%ROBOT2
R2=robotInitialization(R2.Data);


% Randevous parrameters
R2.idXR2=R2.Data.vert(1,1);
R2.idXR1=[];
%... For each robot in the team we have a R1.idXRi=[];
% TODO check if the following params are needed
R2.lastRendevIdRF=0; % this is the last position in R1.idX from the last rendezvous
R2.rendezOffset=zeros(size(R2.Data.vert,1),1);
R2.idRF=ones(max(R1.Data.vert(:,1))+1,1)*(-1);



ind=1;
activeR1=ind<=R1.Data.nEd;
activeR2=ind<=R2.Data.nEd;

edIntRob=R2.Data.edIntRob; %tmp


while (activeR1 || activeR2)   
    if activeR1
        factorR1=processEdgeData(R1.Data.ed(ind,:),R1.Data.obsType,R1.Graph.idX); 
        % keep track of the original final!
        finalR1=factorR1.final;
        R1.idXR1= [R1.idXR1;finalR1];
        % reset ids in case there was a rendezvous
        factorR1.origine=factorR1.origine+R1.rendezOffset(factorR1.origine+1);
        factorR1.final=factorR1.final+R1.rendezOffset(factorR1.final+1);
        R1.Config=addVariableConfig(factorR1,R1.Config,R1.Graph.idX);
        R1.System=addFactor(factorR1,R1.Config,R1.System);
        R1.Graph=addVarLinkToGraph(factorR1,R1.Graph);
        
    end
    if activeR2
        factorR2=processEdgeData(R2.Data.ed(ind,:),R2.Data.obsType,R2.Graph.idX); 
        % keep track of the original final!
        finalR2=factorR2.final;
        R2.idXR2=[R2.idXR2;finalR2];
        % reset ids in case there was a rendezvous
        factorR2.origine=factorR2.origine+R2.rendezOffset(factorR2.origine+1);
        factorR2.final=factorR2.final+R2.rendezOffset(factorR2.final+1);
        R2.Config=addVariableConfig(factorR2,R2.Config,R2.Graph.idX);
        R2.System=addFactor(factorR2,R2.Config,R2.System);
        R2.Graph=addVarLinkToGraph(factorR2,R2.Graph);
    end
    
%     [rdv,edRF,R2.idXR1]=isRendezvous(R2.idXR1,R2.idXR2,edIntRob); % R1-friend, R2-host
%     
%     if   rdv
%         disp('rdv')
%         [R1,R2]=rendezvous(R1,R2,edRF);
%     end

    % update RH.edIntRob ids
    % edIntRob(:,1)=R2.Data.edIntRob(:,1)+R2.rendezOffset(R2.Data.edIntRob(:,1)+1); 
    
    
 % if activeR1
        % nonlinear solve batch R1
      %  [R1.Config,R1.System,R1.Solver]=GaussNewtonOptimization(R1.Config,R1.System,R1.Graph,Solver,Plot); % TODO the plot need to be separated in R1 and R2
    %end
    
    %if activeR2
        % nonlinear solve batch R2
       % [R2.Config,R2.System,R2.Solver]=GaussNewtonOptimization(R2.Config,R2.System,R2.Graph,Solver,Plot);
    %end 
      
    ind=ind+1;
    activeR1=ind<=R1.Data.nEd;
    activeR2=ind<=R2.Data.nEd;
    
end

            
PlotConfig(Plot,R1.Config,R1.Graph,'r','b');
figure
PlotConfig(Plot,R2.Config,R2.Graph,'r','b');


%PlotConfigMultirobot(R2.FLabel,R2.config,R2.F,R2.dim,'r','b','g'); %[0.7 0 1]
%figure
%PlotConfigMultirobot(R1.FLabel,R1.config,R1.F,R1.dim,'r','b','g'); %[0.7 0 1]

