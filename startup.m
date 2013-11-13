proj_setting.subdirs = {'general_tools','tools','plot_tools','chol_qr'};
proj_setting.codeDir = pwd();
addpath(proj_setting.codeDir);

for i = 1:length(proj_setting.subdirs)
    addpath([proj_setting.codeDir '/' proj_setting.subdirs{i}]);
end
 