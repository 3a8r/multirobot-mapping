function [rdv,edRF]=isRendezvous(idXH,edIntRob)
% the rendezvus points are in R.edIntRob
% R.edIntRob(:,1)- host robot RH
% R.edIntRob(:,2)- friend robot RF
idHost=edIntRob(:,1);
rendezRH= ismember(idHost, idXH(end)); % rendez is 1 when RH.idX(end) is involved in a rendezvous
rdv=0;
if sum(rendezRH)
    disp('Rendezvous');
    rdv=1;
    edRF=edIntRob(rendezRH,:);
    edRF=sortrows(edRF,-2); % sort descendent to prepare to cut the graph RF
else
    edRF=[];
end

 
%     % store the randev point from file
%     idRH=find(rendezRH);
%     rendezId=RH.Data.edIntRob(idRH(1),1);
%     [rendezRF,locRF]=ismember(edRF(:,2),RF.Graph.idX);
%     
%     if sum(rendezRF)
%         idRF=find(rendezRF);
%         %remove links whitch cannot be established yet
%         edRF=edRF(idRF(1):end,:);
%         locRF=locRF(idRF(1):end);
%     end
% else
%     edRF=[];
%     locRF=[];
%     rendezId=[];
% end