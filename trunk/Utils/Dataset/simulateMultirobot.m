function simulateMultirobot

dataSet='intel';
saveFiles=0;
maxID=30;
dim=3;

dataFileR1 = [dataFile,'R1.graph'];
dataFileR2 = [dataFile,'R2.graph'];


[vertices,edges]=loadDataSet(dataSet,saveFiles);
[vert, ed]=cut2maxID(maxID, vertices, edges);

 ed=sortrows(ed,[1,-2]);
 nObs=size(ed,1);
 nVert=size(vert,1);
 
 
 
 % Hogman dataset do several retraverses 
 
 halfWay=find(fix(nVert/2)==ed(:,1));
 
 % Robot 1
 
 edR1=ed(1:(halfWay(1)-1),:);
 p0R1 = vert(1,2:end)';
 inx=1:max(edR1(:,1));
 vertR1=vert(ismember(inx,vert(:,1)),:);
 
 %save R1
 R1_file = fopen(dataFileR1,'w');
 for i=1:size(vertR1,1)
     fprintf(R1_file,vertR1(i,1),vertR1(i,2),vertR1(i,3),vertR1(i,4));
 end
 
 for i=1:size(edR1,1)
     fprintf(R1_file,edR1(i,1),ed(i,2),edR1(i,3),edR1(i,4),edR1(i,5),edR1(i,6),edR1(i,7),edR1(i,8),edR1(i,9),edR1(i,10),edR1(i,11));
 end
 
 % Robot 2
 
 edR2=ed(halfWay(1):end,:);
 p0R2 = vert(ed(halfWay(1),2),2:end)';

 % separate the constraints between the two robots
 
 edR2_R1=edR2(find(edR2(:,2)<edR2(1,2)),:); 
 edR2=edR2(find(edR2(:,2)>=edR2(1,2)),:);  % reset indexes first node is edR2(1,2)!
 inx=1:max(edR2(:,1));
 vertR2=vert(ismember(inx,vert(:,1)),:);
 edR2(:,1:2)=edR2(:,1:2)-edR2(1,2);
 vertR2(:,1)=vertR2(:,1)-edR2(1,2);
 
 for i=1:size(vertR2,1)
     fprintf(R2_file,vertR2(i,1),vertR2(i,2),vertR2(i,3),vertR2(i,4));
 end
 
 for i=1:size(edR2,1)
     fprintf(R2_file,edR2(i,1),ed(i,2),edR2(i,3),edR2(i,4),edR2(i,5),edR2(i,6),edR2(i,7),edR2(i,8),edR2(i,9),edR2(i,10),edR2(i,11));
 end
 
 [configR1,edOdoR1]=InitialConfig(edR1,dim,p0R1);
 [configR2,edOdoR2]=InitialConfig(edR2,dim,p0R2);
 
 figure
 PlotConfig(configR1,edR1,dim,'b');
 PlotConfig(configR2,edR2,dim,'r');
 
 %plot interrobot constraints
 nEdges=size(edR2_R1,1);
 p1{nEdges} = [];
 p2{nEdges} = [];
 for i=1:nEdges
    s1=edR2_R1(i,2); % The 2 poses linked by the constraint
    s2=edR2_R1(i,1)-edR2(1,2);
    
    ndx1=(dim*s1)+(1:dim); % Index for the 2 poses
    ndx2=(dim*s2)+(1:dim);
    p1{i}=configR1(ndx1); % The estimation of the two poses
    p2{i}=configR2(ndx2);
    line([p1{i}(1) p2{i}(1)],[p1{i}(2) p2{i}(2)],'Color','g');
 end
 

 
 function printvertex(G_file,id,x,y,theta)
 fprintf(G_file, 'VERTEX2 %d %.6f %.6f %.6f\n',id,x,y,theta,c1,c2,c3,c4,c5,c6);
 end
 
 function printedge(G_file,id1,id2,x,y,theta)
 fprintf(G_file, 'EDGE2 %d %d  %.6f %.6f %.6f %.6f %.6f %.6f %.6f %.6f %.6f\n', id1,id2,x,y,theta,c1,c2,c3,c4,c5,c6);
 end

