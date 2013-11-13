function proj_setting = settings(do_add_path)
if nargin < 1
    do_add_path = true;
end
if isunix
    username = getenv('USER');
    [ret,hostname] = system('echo $HOSTNAME');
    if ret ~= 0
        [ret,hostname] = system('echo $HOST');
    end
    
    assert(ret == 0);
else
    username = getenv('UserName');
    hostname = getenv('COMPUTERNAME'); 
end
proj_setting.username = strtrim(username);
proj_setting.hostname = strtrim(hostname);
 
proj_setting.codeDir = pwd(); 

proj_setting.subdirs = {'general_tools','tools','plot_tools','chol_qr'};

if do_add_path
    addpath(proj_setting.codeDir);
    for i = 1:length(proj_setting.subdirs)
        addpath([proj_setting.codeDir '/' proj_setting.subdirs{i}]);
    end
end


proj_setting.VCInfo = [];

end
