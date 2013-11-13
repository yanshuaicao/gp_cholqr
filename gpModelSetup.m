function GPModel = gpModelSetup(GPModel, Options)

if ischar(GPModel)
    GPModel = struct('gp_name', GPModel);
end
 
GPModel.m = Options.m;
GPModel.n = Options.n;
GPModel.Options = Options;

if isProperlySet(Options, 'run_info_str') 
    GPModel.run_info_str = Options.run_info_str;
else
    GPModel.run_info_str = '';
end

meltStruct(GPModel.Options);

switch GPModel.gp_name
        
    case 'cholqr'

        GPModel.(GPModel.gp_name).delta = GPModel.Options.delta; 
    
        assert(isProperlySet(GPModel.(GPModel.gp_name), 'delta'));
        
        GPModel.run_info_str = [GPModel.run_info_str ...
                            sprintf('_delta%d', GPModel.(GPModel.gp_name).delta)];
        
        
        GPModel.(GPModel.gp_name) = ...
            smartAssignVar(GPModel.(GPModel.gp_name), 'max_swap_per_epoch', ...
                                                     min(60, GPModel.Options.m)); 
                        
        GPModel.run_info_str = [GPModel.run_info_str '_MaxSwapPE' ...
            num2str(GPModel.(GPModel.gp_name).max_swap_per_epoch)];
      
        
        GPModel.(GPModel.gp_name) = ...
            smartAssignVar(GPModel.(GPModel.gp_name),'use_cache', false);
        
        if GPModel.(GPModel.gp_name).use_cache
            GPModel.run_info_str = [GPModel.run_info_str ,  '_cacheOn'];                         	
        end                
                        
        GPModel.(GPModel.gp_name) = ...
                smartAssignVar(GPModel.(GPModel.gp_name), 'random_swap_order', true);

        if GPModel.(GPModel.gp_name).random_swap_order
            GPModel.run_info_str = [GPModel.run_info_str '_RandSwapOrder'];
        end                
                        
        GPModel.(GPModel.gp_name) = ...
            smartAssignVar(GPModel.(GPModel.gp_name), 'swap_info_pivots', true);
        
        if GPModel.(GPModel.gp_name).swap_info_pivots
            
            GPModel.run_info_str = [GPModel.run_info_str '_ReInfo'];

            GPModel.(GPModel.gp_name) = ...
                smartAssignVar(GPModel.(GPModel.gp_name),'max_num_info_revisit',...
                                ceil(GPModel.(GPModel.gp_name).max_swap_per_epoch / 5));

            GPModel.run_info_str = [GPModel.run_info_str , ...
                                      sprintf('_maxNReInfo%d', ...
                                        GPModel.(GPModel.gp_name).max_num_info_revisit)];


            GPModel.(GPModel.gp_name) = ...
                smartAssignVar(GPModel.(GPModel.gp_name),'use_rand_info', true);

            if  GPModel.(GPModel.gp_name).use_rand_info
                GPModel.run_info_str = [GPModel.run_info_str '_RandInfo'];
            else
                error('Not supported');
%                 GPModel.(GPModel.gp_name) = ...
%                     smartAssignVar(GPModel.(GPModel.gp_name),'reShuffleInfoPJmaxBound',...
%                                    log(1+(1/(GPModel.m^2))));
% 
%                 GPModel.(GPModel.gp_name) = ...
%                     smartAssignVar(GPModel.(GPModel.gp_name),'d_ratio', .5);
            end


            GPModel.(GPModel.gp_name) = ...
                smartAssignVar(GPModel.(GPModel.gp_name),'pre_scheduled_reinfo', true);

            if GPModel.(GPModel.gp_name).pre_scheduled_reinfo
                GPModel.run_info_str = [GPModel.run_info_str '_ReInfoPreSched'];
            end
 
            
        end

        
%         GPModel.(GPModel.gp_name) = ...
%             smartAssignVar(GPModel.(GPModel.gp_name),'adapt_info_size_rate',[]);
%         
%         if isProperlySet(GPModel.(GPModel.gp_name),'adapt_info_size_rate')
%             
%             
%  
%             GPModel.run_info_str = [GPModel.run_info_str ,  '_AZR' ...
%                 sprintf('%g',GPModel.(GPModel.gp_name).adapt_info_size_rate)];  
%         end
        
%         GPModel.(GPModel.gp_name) = ...
%             smartAssignVar(GPModel.(GPModel.gp_name),'adapt_reinfo_rate',[]);
%         
%         if isProperlySet(GPModel.(GPModel.gp_name),'adapt_reinfo_rate')
%             
%             GPModel.(GPModel.gp_name).num_info_revisit = 2;
%             
%             GPModel.run_info_str = [GPModel.run_info_str ,  '_ARI' ...
%                 sprintf('%g',GPModel.(GPModel.gp_name).adapt_info_size_rate)];                         	
%         end
        
        
        GPModel.(GPModel.gp_name) = ...
            smartAssignVar(GPModel.(GPModel.gp_name),'do_var_cost', true);
        
        GPModel.do_var_cost = GPModel.(GPModel.gp_name).do_var_cost;
        
        if GPModel.(GPModel.gp_name).do_var_cost
            GPModel.run_info_str = [GPModel.run_info_str,  '_NVF'];                         	
        end

        
    otherwise
        error('Unsupported GP type');
end

% if isProperlySet(GPModel.Options, 'fold_ind')
%     GPModel.run_info_str = [GPModel.run_info_str, sprintf('_fold%d',GPModel.Options.fold_ind)];
% end

