function F_cut=cutGraph(FG,IDcut)

% select the factors between variables in IDcut
n=size(FG,1);
origines=zeros(1,n);
finals=zeros(1,n);
for i=1:n
    origines(i)=FG(i).origine;
    finals(i)=FG(i).final;
end
indF= ismember(finals,IDcut(:,1))&ismember(origines,IDcut(:,1));
F_cut=FG(indF,:);

%F_cut=sortrows(F_cut(indF,:),-2); %the variable that links with the other robot is F_cut(1)

end




