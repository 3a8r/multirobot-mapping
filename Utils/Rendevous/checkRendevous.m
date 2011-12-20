function [RF,RH]=checkRendevous(RF,RH,edIntRob)
% the rendezvus points are in R.edIntRob
% R.edIntRob(:,1)- host robot
% R.edIntRob(:,2)- friend robot


rendezRH= ismember(edIntRob(:,1), RH.idX(end)); % rendez is 1 when RH.idX(end) is involved in a rendez

if sum(rendezRH)
    links=edIntRob(rendezRH,:);
    links=sortrows(links,-2); % sort descendent to prepare to cut the graph RF
    
    % cut the graph RF
    % find if all the RF ids from links are in RF.idX
    
    [rendezRF,locRF]=ismember(links(1,2),RF.idX);
    
    if rendezRF
        
        % store the randev point from file
        idR=find(rendezRH);
        rendezId=RH.edIntRob(idR(1),1);
        
        % master the index for the inter-robot link: links(1,2)
        [links(1,2),RH]=updateID(links(1,2),RH);
        
        % add the inter-robot link       
        RH=addFactorRobot(RH,links(1,:),12);
        
        if size(links,1)>1
            % cut the part of the RF graph
            idCut=RF.idX(RH.lastrendezWithRF+1:locRF);
            RH.lastRendezWithRF=locRF; %to know what part of the graph has been cut for the next time.
                
            
            FRF_cut=cutGraph(RF.Graph.F,idCut);
            
            
            RH.idRF(FRF_cut(1,2))<0 ;
            % master the indexes in FRF_cut
        else 
            RH.lastrendezWithRF=locRF;
        end
        
       RH.rendezOffset(rendezId+1:end)=RH.idX(end)-rendezId;
        
    end
end