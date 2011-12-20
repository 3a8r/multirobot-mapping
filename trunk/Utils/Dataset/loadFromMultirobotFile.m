function [vertices, edges, edges_introb]=loadFromMultirobotFile(dataFileGraph)
vertices=[];
edges=[];
edges_introb=[];
fid = fopen(dataFileGraph);
if isempty(fid) || (fid < 3)
    error('Cannot open the file %s.\n', dataFileGraph);
end
%errorMesage=cat(2,'Reading data from file: ',dataFileGraph,'...');
%disp(errorMesage)
lines=textscan(fid,'%s','delimiter','\n');
fclose(fid);
n=size(lines{1},1); % nombre de liniesma

for i=1:n
    text=lines{1}(i);
    text=cell2mat(text);
    line=textscan(text,'%s');
    if strcmp('VERTEX2',line{1}(1)) || strcmp('VERTEX',line{1}(1))
        v=[];
        for j=2:size(line{1},1)
            v=[v,str2num(cell2mat(line{1}(j)))];
        end
        vertices=[vertices;v];
    elseif strcmp('EDGE2',line{1}(1)) || strcmp('EDGE',line{1}(1))
        e=[];
        for j=2:size(line{1},1)
            e=[e,str2num(cell2mat(line{1}(j)))];
        end
        edges=[edges;e];
        
    else
        if strcmp('EDGE2_R1',line{1}(1)) || strcmp('EDGE_R1',line{1}(1))
            e=[];
            for j=2:size(line{1},1)
                e=[e,str2num(cell2mat(line{1}(j)))];
            end
            edges_introb=[edges_introb;e];
        end
        
    end
end