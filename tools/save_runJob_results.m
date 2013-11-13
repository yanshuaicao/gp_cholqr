function savesucess = save_runJob_results(GPModel, OptHist)

        if strcmp(GPModel.gp_name,'ivm') && isfield(GPModel,'model')
            GPModel  = rmfield(GPModel,'model');
        end
 
        GPModel = strfy_funcs(GPModel);
        OptHist = strfy_funcs(OptHist);
        
        savesucess = safesave(GPModel.Options.saveFileName, 'GPModel', 'OptHist', '-v7.3');                       
        
end