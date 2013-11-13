function [hostname hostinfo] = getHostMachineName()
try
    [status,result] = system('uname -n');
    if status ~= 0 
        warning(['Calling uname error: ' result]);
        hostname = 'unknown';
    else
        hostname = result;
    end
    if nargout > 1
        [status,result] = system('uname -a');
        if status ~= 0 
            warning(['Calling uname error: ' result]);
            hostinfo = 'unknown';
        else
            hostinfo = result;
        end
    end
        
catch e
    hostname = 'unknown';
    hostinfo = 'unknown';
    warning('Calling uname failed:');
    display(e);
end
end