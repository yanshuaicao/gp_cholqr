function struct_root = strfy_funcs(struct_root)

if isa(struct_root,'function_handle')
    
    struct_root = func2str(struct_root);
    
elseif isstruct(struct_root)
    
    fs = fieldnames(struct_root);
    
    for f = 1:length(fs)
        struct_root.(fs{f}) = strfy_funcs(struct_root.(fs{f}));
    end
end

end