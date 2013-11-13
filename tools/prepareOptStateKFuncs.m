function OptState = prepareOptStateKFuncs(OptState, GPModel, trainx, data_var, kern_hyp)

if strcmp(GPModel.kern.type, 'histIntKern') && isfield(GPModel.kern,'KFunc_byInd')
    
    
    OptState.K = @(RI,CI,xx) GPModel.kern.KFunc_byInd(RI,CI,kern_hyp);
    OptState.diagK = GPModel.kern.diagKFunc([], GPModel.n, kern_hyp);
    
elseif strcmp(GPModel.kern.type, 'histIntKern')
    
    OptState.K = @(RI,CI,xx) data_var * ...
                    GPModel.kern.KFunc(GPModel.kern.cellDataPrepFunc(xx(RI,:)), ...
                                       GPModel.kern.cellDataPrepFunc(xx(CI,:)), ...
                                       kern_hyp);
                    
    OptState.diagK = GPModel.kern.diagKFunc([], OptInfo.n, kern_hyp);
    
elseif strcmp(GPModel.kern.type, 'preComputedKern')
    
    if iscell(trainx)
        OptState.K = @(RI, CI, xx) compoundPreCompKs(kern_hyp, RI, CI, xx);
        diagKValues = compoundPreCompKsDiag(kern_hyp, trainx);
        OptState.diagK = diagKValues;
    else
        OptState.K = @(RI, CI, xx) kern_hyp * xx(RI, CI);
        diagKValues = kern_hyp * diag(trainx);
        OptState.diagK =  diagKValues;
    end
    
elseif strcmp(GPModel.kern.type, 'SQExpKern')
    
    OptState.K = @(RI, CI, xx) data_var * GPModel.kern.KFunc(xx(RI,:), xx(CI,:), kern_hyp);
    
    OptState.diagK = data_var * GPModel.kern.diagKFunc([], GPModel.n, kern_hyp);
  
else 
    error('Unsupported kernel');
end

end