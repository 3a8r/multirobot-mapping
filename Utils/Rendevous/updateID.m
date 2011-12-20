
function [idNew,idRF]=updateID(idOld,idRF,idX)

if idRF(idOld+1)<0 % this means that the variable has not been added
    idNew= idX(end)+1;
    idRF(idOld+1)=idNew;
else
    idNew=idRF(idOld+1);
end

% function updateID(id,r)
% % updates the id from file  
% for i=1:size(r,1)
% if id >r(i,1) && id<=r(i+1,1)
%   id=id+r(i,2);
% end
% end