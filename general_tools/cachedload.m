function S = cachedload(fname,varargin)
LOCAL_DIR = '/tmp/';
if ~strcmp(fname(end-3:end),'.mat')
     fname = [fname '.mat'];
end
[fdir, fname_base, fext] = fileparts(fname);
local_fname = fullfile(LOCAL_DIR,[fname_base fext]);


if exist(local_fname,'file')
    if nargout > 0
        S = load(local_fname,varargin{:});
    else
        cmd = build_load_cmd(local_fname,varargin{:});
        evalin('caller',cmd);
    end
else
    if nargout > 0
        S = load(fname,varargin{:});
    else
        cmd = build_load_cmd(fname,varargin{:});
        evalin('caller',cmd);
    end
    system(sprintf('rsync %s %s &',fname,local_fname));
end


end

function cmd = build_load_cmd(fname,varargin)
cmd = sprintf('load(''%s''',fname);
for v = 1:length(varargin)
    cmd = sprintf('%s,%s',cmd,varargin{v});
end
cmd = sprintf('%s);',cmd);
end