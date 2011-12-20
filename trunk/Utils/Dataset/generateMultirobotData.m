function generateMultirobotData

close all

dataSet='10K';
saveFiles=0;
maxID=30;
dim=3;

path=pwd;

dataFile=[pwd,'/Data/',dataSet];

dataFileR1 = [dataFile,'R1.graph'];
dataFileR2 = [dataFile,'R2.graph'];


pathToolbox='~/LAAS/matlab/slam-optim-matlab/Data'; %TODO automaticaly get the toolbox path
[vertices,edges]=loadDataSet(dataSet,pathToolbox,saveFiles);
[vert, ed]=cut2maxID(maxID, vertices, edges);

ed=sortrows(ed,[1,-2]);
nObs=size(ed,1);
nVert=size(vert,1);


% split the dataset in two
cutPoint=fix(nVert/3);

% Robot 1
[srtVert,order] = sort(vert(1:cutPoint,1),'ascend');
R1Indices = ismember(ed(:,1),srtVert)&ismember(ed(:,2),srtVert); % +1 needed because old labels start at 0
edR1 = ed(R1Indices,:);
vertR1=vert(order,:);
p0R1 = vertR1(1,2:end)';

%save R1
R1_file = fopen(dataFileR1,'w');
for i=1:size(vertR1,1)
    printvertex(R1_file,vertR1(i,1),vertR1(i,2),vertR1(i,3),vertR1(i,4));
end

for i=1:size(edR1,1)
    printedge(R1_file,edR1(i,1),edR1(i,2),edR1(i,3),edR1(i,4),edR1(i,5),edR1(i,6),edR1(i,7),edR1(i,8),edR1(i,9),edR1(i,10),edR1(i,11));
end
fclose(R1_file);

% Robot 2

srtVert = ~ismember(vert(:,1),vertR1(:,1));
vertR2=vert(srtVert,:);
R2Indices = ismember(ed(:,1),vertR2(:,1))&ismember(ed(:,2),vertR2(:,1)); % +1 needed because old labels start at 0
edR2 = ed(R2Indices,:);
p0R2 = vertR2(1,2:end)';

% separate the constraints between the two robots
R2_R1Indices = ~(R2Indices | R1Indices);
edR2_R1 = ed(R2_R1Indices,:);

% reset indexes first node is edR2(1,2)!
offset=vertR2(1,1);
edR2(:,1:2)=edR2(:,1:2)-offset;
edR2_R1(:,1)=edR2_R1(:,1)-offset;
vertR2(:,1)=vertR2(:,1)-offset;

%save R2
R2_file = fopen(dataFileR2,'w');
for i=1:size(vertR2,1)
    printvertex(R2_file,vertR2(i,1),vertR2(i,2),vertR2(i,3),vertR2(i,4));
end

for i=1:size(edR2,1)
    printedge(R2_file,edR2(i,1),edR2(i,2),edR2(i,3),edR2(i,4),edR2(i,5),edR2(i,6),edR2(i,7),edR2(i,8),edR2(i,9),edR2(i,10),edR2(i,11));
end

for i=1:size(edR2_R1,1)
    printedgeMR(R2_file,edR2_R1(i,1),edR2_R1(i,2),edR2_R1(i,3),edR2_R1(i,4),edR2_R1(i,5),edR2_R1(i,6),edR2_R1(i,7),edR2_R1(i,8),edR2_R1(i,9),edR2_R1(i,10),edR2_R1(i,11));
end

fclose(R2_file);

[configR1,edOdoR1]=InitialConfig(edR1,dim,p0R1); % TODO use scripts from slam-optim-matlab
[configR2,edOdoR2]=InitialConfig(edR2,dim,p0R2); % TODO use scripts from slam-optim-matlab

figure
PlotConfigSimply(configR1,edR1,dim,'r');% TODO use scripts from slam-optim-matlab
PlotConfigSimply(configR2,edR2,dim,'b');% TODO use scripts from slam-optim-matlab

%plot interrobot constraints
if ~isempty(edR2_R1)
    nEdges=size(edR2_R1,1);
    p1{nEdges} = [];
    p2{nEdges} = [];
    for i=1:nEdges
        s1=edR2_R1(i,2); % The 2 poses linked by the constraint
        s2=edR2_R1(i,1);
        
        ndx1=(dim*s1)+(1:dim); % Index for the 2 poses
        ndx2=(dim*s2)+(1:dim);
        p1{i}=configR1(ndx1); % The estimation of the two poses
        p2{i}=configR2(ndx2);
        line([p1{i}(1) p2{i}(1)],[p1{i}(2) p2{i}(2)],'Color','g'); %[0.7 0 1] - violet
    end
end

end

%TODO move to separate files for reuse

function printvertex(G_file,id,x,y,theta)
fprintf(G_file, 'VERTEX2 %d %.6f %.6f %.6f\n',id,x,y,theta);
end

function printedge(G_file,id1,id2,x,y,theta,c1,c2,c3,c4,c5,c6)
fprintf(G_file, 'EDGE2 %d %d  %.6f %.6f %.6f %.6f %.6f %.6f %.6f %.6f %.6f\n', id1,id2,x,y,theta,c1,c2,c3,c4,c5,c6);
end

function printedgeMR(G_file,id1,id2,x,y,theta,c1,c2,c3,c4,c5,c6)
fprintf(G_file, 'EDGE2_R1 %d %d  %.6f %.6f %.6f %.6f %.6f %.6f %.6f %.6f %.6f\n', id1,id2,x,y,theta,c1,c2,c3,c4,c5,c6);
end


