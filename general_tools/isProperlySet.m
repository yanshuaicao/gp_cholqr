function boolTrueIfSet = isProperlySet(structName,fieldName)
boolTrueIfSet = isfield(structName,fieldName) && ~isempty(structName.(fieldName));
end