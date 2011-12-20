function [RF,RH]=rendezvous(RF,RH,edRF)
% the rendezvus points are in R.edIntRob
% R.edIntRob(:,1)- host robot RH
% R.edIntRob(:,2)- friend robot RF
for i=1:size(edRF,1)

    
    ed=edRF(i,:);
    idHost=ed(1); % acording to the conevntion!
    idFriend=ed(2);
    
    if find(idFriend,RH.idXF) %TODO this will change for each pair of robots
      % We need a map between the id in the ro
    else    
    lastIdHost=RH.Graph.idX(end);
    ed(2)=lastIdHost+1;
    
    end
    
    %change idFriend into idHost coordinates and update the idRF
    
    [interRobLink(2),RH.idRF]=updateID(interRobLink(2),RH.idRF,RH.Graph.idX);
    factorR=processEdgeData(interRobLink);%TODO check if it realy need to invert edge!!
    

    
    %TODO at some point update the RH.idXF
    
    
        if ~ismember(edRF(i,1),RH.idXF);
            RH.idXF=[idXF;edRF(i,1)];
        end
    
    
    % add the inter-robot link
    
    RH.Config=addVariableConfig(factorR,RH.Config,RH.Graph.idX);
    RH.System=addFactor(factorR,RH.Config,RH.System);
    RH.Graph=addVarLinkToGraph(factorR,RH.Graph);
    disp('add interrobot link')
    
    if size(edRF,1)>1
        
        % check if the variable is already in the RH graph
        %edRF(:,1:2)
        
        for i=2:size(edRF,1)
            if RH.idRF(edRF(i,2)+1)>0
                interRobLink=edRF(1,:);
                factorR=processEdgeData(interRobLink);
                [factorR.final,RH.idRF]=updateID(factorR.final,RH.idRF,RH.Graph.idX);
                
                RH.Config=addVariableConfig(factorR,RH.Config,RH.Graph.idX);
                RH.System=addFactor(factorR,RH.Config,RH.System);
                RH.Graph=addVarLinkToGraph(factorR,RH.Graph);
                disp('add link with variables already in the RH state')
            else
                % Cut the Friend Graph (RF)
                IDcut=RF.Graph.idX(RH.lastRendevIdRF+1:locRF);
                %TODO cutGraph DOES NOT WORK
                F_cut=cutGraph(RF.Graph.F,IDcut);
                ind_cut=1;
                while ind_cut<=size(F_cut,1)
                    link=F_cut(ind_cut,:);
                    %[factorR.data(1),RH]=updateID(factorR.data(1),RH);
                    %[factorR.data(2),RH]=updateID(factorR.data(2),RH);
                    
                    [factorR.origine,RH.idRF]=updateID(factorR.origine,RH.idRF,RH.Graph.idX);
                    [factorR.final,RH.idRF]=updateID(factorR.final,RH.idRF,RH.Graph.idX);
                    %%%TODO here there is a mistake!!!!!
                    
                    RH.Config=addVariableConfig(factorR,RH.Config,RH.Graph.idX);
                    RH.System=addFactor(factorR,RH.Config,RH.System);
                    RH.Graph=addVarLinkToGraph(factorR,RH.Graph);
                    disp('add link with new variables')
                    ind_cut=ind_cut+1;
                end
            end
            
        end
        
    else
        RH.lastrendezWithRF=locRF;
    end
    RH.rendezOffset(rendezId+2:end)=RH.idX(end)-rendezId;
end

