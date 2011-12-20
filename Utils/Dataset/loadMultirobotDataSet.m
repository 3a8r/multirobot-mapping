function [vertices,edges,edges_introb,dataFile]=loadMultirobotDataSet(dataSet,saveFile)
% the function loads the data file (toro format) and create the undirected graph

% Data sets:
% 
% 	'intel'  - 'data/iSAM/Laser/intel.graph'
% 	'intel-gfs'  - 'data/iSAM/Laser/intel.gfs.graph'
% 	'Killian-gfs'  - 'data/iSAM/Laser/Killian.gfs.graph'
% 	'Killian'  - 'data/iSAM/Laser/Killian.graph'
% 	'Killian-noised'   - 'data/iSAM/Laser/Killian-noised.graph'
% 	'3'  - 'borg/toro/data/2D/w3-odom.graph'
% 	'100'  - 'borg/toro/data/2D/w100-odom.graph'
% 	'10K'  - 'borg/toro/data/2D/w10000-odom.graph'
% 	'olson'   - 'data/iSAM/ISAM2/olson06icra.txt'
% 	'victoria'  - 'data/iSAM/ISAM2/victoria_park.txt'
% 	'beijing'  - 'data/BeijingData/beijingData_trips.log'
switch dataSet
    case 'intelR1'
        dataFileGraph = '~/LAAS/matlab/multirobot-mapping/Data/intelR1.graph';
    case 'intelR2'
        dataFileGraph = '~/LAAS/matlab/multirobot-mapping/Data/intelR2.graph';
    case '10KR1'
        dataFileGraph = '~/LAAS/matlab/multirobot-mapping/Data/10KR1.graph';
    case '10KR2'
        dataFileGraph = '~/LAAS/matlab/multirobot-mapping/Data/10KR2.graph';
        %ROSACE
    case 'R1_2D'
        dataFileGraph = '~/LAAS/datasets/Rosace/R1_2D.graph';
    case 'R2_2D'
        dataFileGraph = '~/LAAS/datasets/Rosace/R2_2D.graph';
    case 'R3_2D'
        dataFileGraph = '~/LAAS/datasets/Rosace/R3_2D.graph';
    otherwise
        error('Dataset does not exist!');
end


dataFileMat=cat(2,dataFileGraph(1:end-6),'.mat');

%make sure that there are no other variables called vertices, edges
clear vertices;
clear edges;



% read the file
if exist(dataFileMat,'file')
    load(dataFileMat);
    disp('Loading ed, ver from MAT file ...')
    if ~exist('edges_introb')
        edges_introb=[];
    end;
else
    [vertices, edges,edges_introb]=loadFromMultirobotFile(dataFileGraph);
    disp('Read ed, ver from GRAPH file ...')
end
if saveFile
    %save data to a mat file
    save(dataFileMat,'vertices','edges','edges_introb');
end
dataFile=dataFileGraph(1:end-6);