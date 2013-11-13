function OptState = initializeOptState(GPModel)
OptState.size_params.n = GPModel.n;
OptState.size_params.m = GPModel.m;

switch GPModel.gp_name 
    case 'cholqr'
        OptState.size_params.delta = GPModel.cholqr.delta;

        OptState.size_params.k = OptState.size_params.m + 1;
 
        
%         if isProperlySet(GPModel.cholqr,'adapt_info_size_rate')
%             OptState.size_params.kadv = OptState.size_params.k + min(5,OptState.size_params.delta - 1); 
%         else
        OptState.size_params.kadv = OptState.size_params.k + ...
                                        OptState.size_params.delta - 1; 
%         end
        
%         if isProperlySet(GPModel.cholqr,'adapt_reinfo_rate')
%             OptState.num_info_revisit = 2;
%         else
%             OptState.num_info_revisit = [];
%         end
                                
        OptState.hyp = GPModel.kern.hyp;  
        
        OptState.usedInfoPInds = false(GPModel.n, 1);
        
 
        OptState.P = GPModel.I_ini;
        rand_remain_inds = setdiff(1:OptState.size_params.n, OptState.P);
        rand_remain_inds = rand_remain_inds(randperm(length(rand_remain_inds)));
        OptState.P = [reshape(OptState.P, 1, []) reshape(rand_remain_inds, 1, [])];

        OptState.usedInfoPInds(OptState.P(OptState.size_params.k:...
                                            OptState.size_params.kadv)) = true;

        OptState.I = OptState.P(1:GPModel.m);                               
         
        
        if isProperlySet(GPModel.cholqr, 'max_swap_per_epoch') &&  ...
                GPModel.cholqr.max_swap_per_epoch < GPModel.m
            
            OptState.pred_pivots_ages = zeros(GPModel.m,1);
            
        else
            
            OptState.pred_pivots_ages = [];
            
        end
        
    otherwise
        error('unsupported')
    
end

end