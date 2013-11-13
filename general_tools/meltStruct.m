function meltStruct(MyStruct,f_names)
if nargin < 2 
    if ~isempty(MyStruct)
        f_names = fieldnames(MyStruct);    
    else
        f_names = [];
    end
end

for f = 1:length(f_names)
    assignin('caller', f_names{f}, MyStruct.(f_names{f}));
end
end