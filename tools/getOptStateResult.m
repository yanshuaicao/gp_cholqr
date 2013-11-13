function results = getOptStateResult(OptState,resultFieldNamesFinal,resultFieldNamesAll,nanIfNo)
optStateVersion = getVersion(OptState);
if nargin < 4
    nanIfNo = false;
end
if iscell(resultFieldNamesFinal) 
    N = length(resultFieldNamesFinal);
else
    N = 1;
end

for r = 1:N
    
    if iscell(resultFieldNamesFinal) 
        
        fName = resultFieldNamesFinal{r};
        
    else
        
        fName = resultFieldNamesFinal;
        
    end
    
    switch optStateVersion
        
        case 'reiterative'
            
            results{r} = getOptStateResult_gpld_rei(OptState,fName,nanIfNo);
            
        case 'incremental'
            
            error('Not implemented');
            
        case 'spgp'
            
            results{r} = getOptStateResult_spgp(OptState,fName);
            
        case 'spgp-jumpstart'
            
            results{r} = getOptStateResult_spgp_jumpstart(OptState,fName);
            
        case {'spgp-onlyhyp', 'spgp-onlyhyp-jumpstart'}
            
            results{r} = getOptStateResult_spgp_onlyhyp_jumpstart(OptState,fName);    
            
        case 'ivm'
            
            results{r} = getOptStateResult_ivm(OptState,fName);   
            
        case 'sod'
            
            results{r} = getOptStateResult_sod(OptState,fName);    
            
        case 'spgp-old'
            
            error('Not implemented');
            
        otherwise
            
            error('Not implemented');
            
    end
end
%%
if nargin > 2
    if iscell(resultFieldNamesAll) 
        M = length(resultFieldNamesAll);
    else
        M = 1;
    end
    for r = 1:M
        if iscell(resultFieldNamesAll) 
            fName = resultFieldNamesAll{r};
        else
            fName = resultFieldNamesAll;
        end

        switch optStateVersion

            case 'reiterative'

                error('gpld-reiterative does not store all historical OptStates');

            case 'incremental'

                error('Not implemented');

            case 'spgp'

                results{N+r} = getOptStateResult_spgp(OptState,fName,1);

            case 'spgp-jumpstart'

                results{N+r} = getOptStateResult_spgp_jumpstart(OptState,fName,1);
                
            case {'spgp-onlyhyp', 'spgp-onlyhyp-jumpstart'}

                results{N+r} = getOptStateResult_spgp_onlyhyp(OptState,fName,1);       

            case 'spgp-old'
                error('Not implemented');
            otherwise
                error('Not implemented');
        end
    end
end

end

function versionName = getVersion(OptState)
    if length(OptState) == 1 && isfield(OptState,'nmllPostContHist')
        versionName = 'reiterative';
    elseif iscell(OptState) && isfileNameStartingWith(getFileNameFromStruct(OptState{1}),'spgp-onlyhyp-jumpstart')  
        versionName = 'spgp-onlyhyp-jumpstart';
    elseif iscell(OptState) && isfileNameStartingWith(getFileNameFromStruct(OptState{1}),'spgp-onlyhyp')
        versionName = 'spgp-onlyhyp';
    elseif ~iscell(OptState) && length(OptState) == 1 && isfileNameStartingWith(getFileNameFromStruct(OptState),'gpld-incremental')
        versionName = 'incremental-old';
    elseif isfileNameStartingWith(getFileNameFromStruct(OptState{1}),'gpld-incremental')
        versionName = 'incremental';
    elseif length(OptState) > 1 && isfileNameStartingWith(getFileNameFromStruct(OptState{1}),'spgp-jumpstart')
        versionName = 'spgp-jumpstart';
    elseif length(OptState) > 1 && ...
            (~isfileNameStartingWith(getFileNameFromStruct(OptState{1}),'jumpstart') && ...
            isfileNameStartingWith(getFileNameFromStruct(OptState{1}),'spgp'))
        
        versionName = 'spgp';
    elseif length(OptState) == 1 && ...
            (~isfileNameStartingWith(getFileNameFromStruct(OptState),'jumpstart') && ...
             isfileNameStartingWith(getFileNameFromStruct(OptState),'spgp'))
        versionName = 'spgp-old';
    elseif iscell(OptState) && isfileNameStartingWith(getFileNameFromStruct(OptState{1}),'ivm') 
        versionName = 'ivm';
    elseif iscell(OptState) && isfileNameStartingWith(getFileNameFromStruct(OptState{1}),'sod') 
        versionName = 'sod';
    else
        error('Unrecognized version');
    end
end
function fname = getFileNameFromStruct(Opt)
if isfield(Opt,'saveFileName')
    fname = Opt.saveFileName;
else
    fname = Opt.optInfo.saveFileName;
end
end

function boolans = isfileNameStartingWith(fullpath,prefix)
[~, name, ~] = fileparts(fullpath) ;
boolans = any(1==strfind(name,prefix));
end