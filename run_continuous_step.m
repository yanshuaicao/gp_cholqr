function OptState = run_continuous_step(OptState, GPModel, trainx, trainy)

if GPModel.Options.nConPerStep > 0
    
    funObj = build_continuous_objective_fcn(OptState, GPModel, trainx, trainy);        

    switch GPModel.gp_name
        
            case 'cholqr'
                OptState.hyp = optimizeContHyperParams( funObj, OptState.hyp, ...
                                                        GPModel.kern.hyp_LB, ...
                                                        GPModel.kern.hyp_UB, ...
                                                        GPModel.Options.nConPerStep,...
                                                        GPModel.Options.contHypOptMethodName);
        otherwise
            error('Unsupported')
    end
 
end

end