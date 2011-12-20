function [Config, System, Graph]=addFactorRobotGeneral( factorR,Config, System, Graph)
if factorR(end)~=99999
     if factorR(2)>factorR(1)
         % in this case we need to invert the edge
         factorR(1:2)=factorR(2:-1:1);
         factorR(3:5)=InvertEdge(factorR(3:5)')';
     end
    if (ismember(factorR(2),Graph.idX))
        if(ismember(factorR(1),Graph.idX))
           factorType='poseConstr'; 
        else
            factorType='odometric';
        end
    else 
        error('Disconnected factor!!')
        return;
    end
    
else
    if(ismember(factorR(1),Graph.idX))
        factorType='landmark';
    else
        factorType='new_landmark';
    end
end


% 
switch factorType
    
    case 'odometric'   
        Config=addPose(factorR,Config); 
        System=addFactorPose(factorR,Config,System);
        Graph.idX= [Graph.idX;factorR(1)];
        Graph.F=[Graph.F;factorR];
        
    case 'poseConstr'
        System=addFactorPose(factorR,Config,System);
        Graph.F=[Graph.F;factorR];
        
    case 'new_landmark'
        Config=addLandmark(factorR,Config);
        System=addFactorLandmark(factorR,Config,System);
        Graph.idX= [Graph.idX;factorR(1)];
        Graph.F=[Graph.F;factorR];
        
    case 'landmark'
        System=addFactorLandmark(factorR,Config,System);
        Graph.F=[Graph.F;factorR];
end

