function S = safeload(name)
lsuccess = false;
ntrial = 5;

while ~lsuccess && ntrial > 0
    try 
        if nargout > 0 
            S = load(name);
        else
            evalin('caller',sprintf('load(''%s'')',name));
        end
        lsuccess = true;
    catch e
        disp(e);
        fprintf('loading %s failed, try again...\n',name)
        ntrial = ntrial - 1;
        pause(5);
    end
end
end