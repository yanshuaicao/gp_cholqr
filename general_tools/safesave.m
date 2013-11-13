function savesucess = safesave(fname, varargin)
savesucess = false;
trial = 5;
 
save_cmd_str = sprintf('save(''%s''',fname);
for v = 1:length(varargin)
    save_cmd_str = sprintf('%s,''%s''', save_cmd_str, varargin{v});
end
save_cmd_str = sprintf('%s);', save_cmd_str);

while trial > 0 && ~savesucess
    try 
        evalin('caller', save_cmd_str);
        savesucess = true;
    catch e
        fprintf('Saving failed try again in 10 seconds\n');
        pause(10);
        trial = trial - 1;
    end
end
if ~savesucess
    fprintf('Failed to save, skip\n');
end
end