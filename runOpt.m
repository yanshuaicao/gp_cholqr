function [GPModel, OptHist, OptState, PredModel] = runOpt(GPModel, OptState, OptHist, trainx, trainy, pred_func)

fprintf('Starting optimization: %s\n', GPModel.Options.saveFileName);

do_prediciton = exist('pred_func','var') && isa(pred_func,'function_handle');

for epoch = 0:GPModel.Options.maxEpoch
    OptState.epoch = epoch;   
    
    if epoch > 0 
        %% train 
        timer_opt = tic;
         %continous step
        OptState = run_continuous_step(OptState, GPModel, trainx, trainy);
 
        %discrete step
        discretetimer_opt = tic;
        switch GPModel.gp_name 
            case 'cholqr'
                OptState = cholqr_discrete_one_pass(OptState, GPModel, trainx, trainy); 
                
            otherwise
                error('unsupported')
        end

        OptHist.discretetime_hist{epoch+1} = toc(discretetimer_opt);

        OptHist.comptime_hist{epoch+1} = toc(timer_opt);
    else
        %epoch 0 doesn't train, just pred and record ini model score
        OptHist.discretetime_hist{epoch+1} = 0;
        OptHist.comptime_hist{epoch+1} = 0;
    end
 
    funObj = build_continuous_objective_fcn(OptState, GPModel, trainx, trainy);
    
    [train_obj_val, ~, PredModel] =  funObj(OptState.hyp);                                     
    %% check for termination
    if epoch > 0
 
        if GPModel.do_var_cost
             rel_change = (OptHist.nvf_hist{epoch} - train_obj_val) ...
                            / abs(OptHist.nvf_hist{epoch});
        else
             rel_change = (OptHist.nmll_hist{epoch} - train_obj_val) ...
                            / abs(OptHist.nmll_hist{epoch});
        end

        if rel_change < GPModel.Options.obj_rel_change_threshold  
            fprintf('Terminating...\n');

            if GPModel.Options.do_save_result
                save_runJob_results(GPModel, OptHist);
            end

            break;
        end
    end   
    
    %% update GPModel; store important experimental results into OptHist
    [sis, data_var, noise_var, kern_hyp] = extract_current_params(OptState, GPModel);
    
    OptHist.sis_hist{epoch+1} = sis; 
    OptHist.hyp_hist{epoch+1} = OptState.hyp;
    
    if GPModel.do_var_cost 
        nvf = train_obj_val; 
        
        % compute the negative log likelihood for record (not really needed by algo)
        % can be done much faster by just subtracting the trace term, but don't
        % really care here. 
        
        GPModel_tmp = GPModel;
        GPModel_tmp.do_var_cost = false;

        funObj_tmp = build_continuous_objective_fcn(OptState, GPModel_tmp, ...
                                                    trainx, trainy); 
                                        
        OptHist.nmll_hist{epoch+1} = funObj_tmp(OptState.hyp);                                  
    else
        OptHist.nmll_hist{epoch+1} = train_obj_val; 
    end

    if do_prediciton
        [~, ~, snlp, smse] = ...
            pred_func(data_var, noise_var, kern_hyp, sis, PredModel, trainx);
        
        OptHist.snlp_hist{epoch+1} = snlp;
        OptHist.smse_hist{epoch+1} = smse;
    end
    
    if GPModel.do_var_cost
        OptHist.nvf_hist{epoch+1} = nvf;
    end
    
%     if exist('is_accepted','var') && isglobal(is_accepted)
%         OptHist.is_accepted = is_accepted;
%         OptHist.proposed_i = proposed_i;
%         OptHist.proposed_j = proposed_j;
%     end

    GPModel.kern.hyp = OptState.hyp;
    GPModel.sis = sis;
    %% Print progress
 
    total_comptime = sum(cell2mat(OptHist.comptime_hist(1:epoch+1)));
    
    if GPModel.do_var_cost
        if ~do_prediciton
            fprintf('epoch %d of %d; time %0.2f; VAR %g; NMLL %g\n',...
                                     epoch, GPModel.Options.maxEpoch, ...
                                     total_comptime, ...
                                     OptHist.nvf_hist{epoch+1}, ...
                                     OptHist.nmll_hist{epoch+1});
        else
            fprintf('epoch %d of %d; time %0.2f; VAR %g; NMLL %g; SMSE %g; SNLP %g\n',...
                                     epoch, GPModel.Options.maxEpoch, ...
                                     total_comptime, ...
                                     OptHist.nvf_hist{epoch+1}, ...
                                     OptHist.nmll_hist{epoch+1} ,...
                                     OptHist.smse_hist{epoch+1} ,...
                                     OptHist.snlp_hist{epoch+1});
        end
    else
        if ~do_prediciton
            fprintf('epoch %d of %d; time %0.2f; NMLL %g\n',...
                                 epoch, GPModel.Options.maxEpoch, ...
                                 total_comptime, ...
                                 OptHist.nmll_hist{epoch+1});
                                  
        else
        fprintf('epoch %d of %d; time %0.2f; NMLL %g; SMSE %g; SNLP %g\n',...
                                 epoch, GPModel.Options.maxEpoch, ...
                                 total_comptime, ...
                                 OptHist.nmll_hist{epoch+1} ,...
                                 OptHist.smse_hist{epoch+1} ,...
                                 OptHist.snlp_hist{epoch+1});
        end
    end
                  
                         
    fprintf('%s\n', GPModel.Options.saveFileName);
   
end
end
