function [GPModel, trainx, trainy] = postSetupProcess(GPModel, trainx, trainy)
                                                                                                    
 
switch GPModel.Options.sis_ini_method
    
    case {'RAND'}
        
        GPModel.I_ini = randperm(GPModel.n);
        GPModel.I_ini = GPModel.I_ini(1:GPModel.m);
        GPModel.run_info_str = sprintf('%s_SIS-INI-RAND', GPModel.run_info_str);
        
    case {'CLUMPED-RAND-CENTRE'}
        rand_ind = randperm(GPModel.n);
        GPModel.Options.CLUMPED_CENTRE_X = trainx(rand_ind(1),:);
        
        GPModel = find_ini_I_given_x(GPModel, trainx);
        GPModel.run_info_str = sprintf('%s_%s', GPModel.run_info_str, 'SIS-INI-CLUMPED-RC');
        
    case {'CLUMPED-GIVEN-CENTRE'}

        GPModel = find_ini_I_given_x(GPModel, trainx);
        GPModel.run_info_str = sprintf('%s_%s', GPModel.run_info_str, 'SIS-INI-CLUMPED-GC');
        
%     case {'INC_BUILDUP_START'}
%         
%         if strcmp(GPModel.gp_name,'cholqr')
%             GPModel.Options.run_info_str = sprintf('%s_SIS-INI-INC', GPModel.Options.run_info_str);
%         else
%             error('INC_BUILDUP_START mode unsupported for GP %s',GPModel.gp_name);
%         end
        
    otherwise
        error('Unsupported')
end
                                                                               
%%                                            
GPModel.Options.totalNSteps = GPModel.Options.maxEpoch * ...
                              GPModel.Options.nConPerStep * ...
                              (GPModel.m + length(GPModel.Options.hyp0));
                          
GPModel.Options.nConPerStep = min(20, max(15, 2*length(GPModel.Options.hyp0)));
GPModel.Options.maxEpoch = ceil(GPModel.Options.totalNSteps / GPModel.Options.nConPerStep); 
    
GPModel.Options.obj_rel_change_threshold = 1e-4;

GPModel.Options.saveFileName = sprintf('%s%s-%s-%s_m%d_%s_me%d_nc%d_%s_rseed%d_job%d.mat',...
                                        GPModel.Options.resultDir, ...
                                        GPModel.gp_name, ...
                                        GPModel.Options.kern_name_str, ...
                                        GPModel.Options.dataSetName,...
                                        GPModel.m, ...
                                        GPModel.run_info_str,...
                                        GPModel.Options.maxEpoch,  ...
                                        GPModel.Options.nConPerStep, ...
                                        GPModel.Options.contHypOptMethodName, ...
                                        GPModel.Options.r_seed, ...
                                        GPModel.Options.permanentID);
                                    
GPModel.Options.saveFileName = shorten_name(GPModel.Options.saveFileName);

end

function GPModel = find_ini_I_given_x(GPModel, trainx)

    ds_2_centre = sq_dist(GPModel.Options.CLUMPED_CENTRE_X, trainx);
    
    [~, GPModel.I_ini] = sort(ds_2_centre);
     
    GPModel.I_ini = GPModel.I_ini(1:GPModel.m);
    
end
