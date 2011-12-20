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
        dataFileGraph = '~/LAAS/matlab/MultirobotMapping/Data/intelR1.graph';
    case 'intelR2'
        dataFileGraph = '~/LAAS/matlab/MultirobotMapping/Data/intelR2.graph';
    case '10KR1'
        dataFileGraph = '~/LAAS/matlab/MultirobotMapping/Data/10KR1.graph';
    case '10KR2'
        dataFileGraph = '~/LAAS/matlab/MultirobotMapping/Data/10KR2.graph';
        %ROSACE
    case 'R12D'
        dataFileGraph = '~/LAAS/matlab/MultirobotMapping/Data/R12D.graph';
    case 'R22D'
        dataFileGraph = '~/LAAS/matlab/MultirobotMapping/Data/R22D.graph';
    case 'R32D'
        dataFileGraph = '~/LAAS/matlab/MultirobotMapping/Data/R32D.graph';
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
    disp('Loading ed, ver from file ...')
else
    [vertices, edges,edges_introb]=loadFromMultirobotFile(dataFileGraph);
end
if saveFile
    %save data to a mat file
    save(dataFileMat,'vertices','edges','edges_introb');
end
dataFile=dataFileGraph(1:end-6);