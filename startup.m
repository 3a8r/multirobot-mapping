% Matlab code to test Multi-robot SLAM strategies
%
%   
%   
clc;
disp(' ');
disp('         Multi-robot SLAM toolbox');
disp('              by Viorela Ila');
disp('    requires slam-optim-matlab toolbox');
disp(' ');
disp(' ');

SuiteSparsePath_ela='~/Work_mac/code/SuiteSparse';
SuiteSparsePath_others='~/borg/SuiteSparse';
slam_optimPath='~/LAAS/matlab/slam-optim-matlab';

if exist(SuiteSparsePath_ela,'dir')
    path(path,genpath(SuiteSparsePath_ela));
    path(path,genpath(slam_optimPath));
    path(path,genpath(pwd));
elseif exist(SuiteSparsePath_others,'dir')
    path(path,genpath(SuiteSparsePath_others));
    path(path,genpath(slam_optimPath));
    path(path,genpath(pwd));
else
    disp(' Can not find SuiteSparse !! ');
    path(path,genpath(slam_optimPath));
    path(path,genpath(pwd));
end
clear SuiteSparsePath_ela;
clear SuiteSparsePath_others;
clear slam_optim_Path;
