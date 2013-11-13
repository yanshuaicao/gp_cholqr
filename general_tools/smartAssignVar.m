function MyStruct = smartAssignVar(MyStruct, var_name, default_val)

    if ~ isProperlySet(MyStruct, var_name)
       if evalin('caller', sprintf('exist(''%s'',''var'')', var_name))
           MyStruct.(var_name) = evalin('caller', var_name);
       elseif exist('default_val','var')
           MyStruct.(var_name) = default_val;
       else
           error('Variable %s does not exist', var_name);
       end
    end
    
end