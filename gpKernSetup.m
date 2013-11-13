function GPModel = gpKernSetup(GPModel, trainx, trainy)
    
%% decide what kernel to use

if ~isProperlySet(GPModel,'kern') || ~isProperlySet(GPModel.kern, 'type')
    
    if isProperlySet(GPModel.Options, 'preComputedKern') 
       GPModel.kern.type = 'preComputedKern';
       
    elseif isProperlySet(GPModel.Options,'kern')
        
       GPModel.kern.type = GPModel.Options.kern;
       
    elseif isProperlySet(GPModel.Options, 'hypIniMethod') 
        
        switch GPModel.Options.hypIniMethod
            
            case 'PyHistMatchKernIni'
                GPModel.kern.type = 'histIntKern';
                
            case {'UnitIniScale', 'UnitScale', 'useUnitIniScale','DimWiseSTD'}
                
                GPModel.kern.type = 'SQExpKern';
                
            otherwise
                error('unsupported kernel type');
        end
    else
        
        GPModel.kern.type = 'SQExpKern';
        warning('Unable to find clue about type of kernel to use, using %s', GPModel.kern.type);
        
    end
end

%% initialize hyp 

GPModel.Options.kern_name_str = GPModel.kern.type;
 
if ~isProperlySet(GPModel.kern, 'hyp')

    switch GPModel.kern.type
        case 'preComputedKern'
            
            GPModel.Options.kern_name_str = [GPModel.Options.kern_name_str '-' GPModel.Options.kern];
            
            if isProperlySet(GPModel.Options, 'hyp0')
                GPModel.kern.hyp = GPModel.Options.hyp0;
            else
                if iscell(trainx)
                    std_trainy = std(trainy);
                    cc = arrayfun(@(jj) std_trainy/mean(diag(trainx{jj})), 1:length(trainx));
                    cc = reshape(cc,[],1);
                else
                    cc = std(trainy)/mean(diag(trainx));
                end
                
                GPModel.kern.hyp = [mean(cc)/4; cc];
            end
            
            %GPModel.kern.K = trainx; %the precomputed K is passed in instead of trainx
            
            GPModel.kern.extract_data_var = @(hyp) [];
            GPModel.kern.extract_noise_var = @(hyp) hyp(1);
            GPModel.kern.extract_kern_hyp = @(hyp) hyp(2:end); 
            
            GPModel.kern.pack_into_hyp = @(data_var, noise_var, kern_hyp) ...
                                            [noise_var; reshape(kern_hyp,[],1)];
                                        
            GPModel.kern.hyp_LB = GPModel.Options.pos_guard_bound * ones(size(GPModel.kern.hyp));
            GPModel.kern.hyp_UB = inf(size(GPModel.kern.hyp));
            
        case 'histIntKern'
             

            if isProperlySet(GPModel.Options,'hyp0')

                GPModel.kern.hyp = GPModel.Options.hyp0;

            else
                GPModel.kern.hyp = initializePyHistMatchHyp( [], ...
                                                             trainy,...
                                                             'PyHistMatchKernIni',...
                                                             GPModel.Options.dataSetName, ...
                                                             GPModel.Options.do_rand_corrupt_hyp_ini);
            end
        
            GPModel.kern.cellDataPrepFunc = @(data) histChannelMat2Cell(data, GPModel.Options.dataSetName);
            
            Xcells = GPModel.kern.cellDataPrepFunc(trainx);
            
            try 
                [~,HIQ] = histInterKern(@hist_isect_c, Xcells, Xcells,...
                                        GPModel.kern.hyp(2:end));

                                    
                GPModel.kern.KFunc_byInd = @(RI,CI,kern_hyp) ...
                                               histInterKern(@hist_isect_c,...
                                                             [],...
                                                             [],...
                                                             kern_hyp,...
                                                             HIQ(RI,CI,:));                                          

            catch err
                
                if ~strcmp(err.identifier, 'MATLAB:nomem')
                    rethrow(err);
                end
                
            end
            
            GPModel.kern.KFunc = @(X0, X1, kern_hyp) histInterKern(@hist_isect_c, ...
                                                                   X0, ...
                                                                   X1, ...
                                                                   kern_hyp);

            GPModel.kern.diagKFunc = @(xx, nn, kern_hyp) sum(kern_hyp) * ones(nn,1);

            
            GPModel.kern.dKFunc_dkernhyp = @(X0, X1, kern_hyp, dd, varargin) ...
                                                    histInterKern_dp(@hist_isect_c, ...
                                                                     X0, ...
                                                                     X1, ...
                                                                     kern_hyp, ...
                                                                     dd, ...
                                                                     varargin{:}); 
 
            
            GPModel.kern.extract_data_var = @(hyp) 1;
            GPModel.kern.extract_noise_var = @(hyp)hyp(1);
            GPModel.kern.extract_kern_hyp = @(hyp) hyp(2:end); 
            GPModel.kern.pack_into_hyp = @(data_var,noise_var,kern_hyp) ...
                                             [noise_var; reshape(kern_hyp,[],1)];

            GPModel.kern.hyp_LB = GPModel.Options.pos_guard_bound * ones(size(GPModel.kern.hyp));
            GPModel.kern.hyp_UB = inf(size(GPModel.kern.hyp));

        case 'SQExpKern'

            if isProperlySet(GPModel.Options,'hyp0')

                GPModel.kern.hyp = GPModel.Options.hyp0;

            else
                if isProperlySet(GPModel.Options, 'hypIniMethod')

                    GPModel.kern.hyp = initializeSQExpHyp(trainx,...
                                                          trainy, ...
                                                          GPModel.Options.hypIniMethod,...
                                                          GPModel.Options.do_rand_corrupt_hyp_ini);
                else

                    GPModel.kern.hyp = initializeSQExpHyp(trainx, ...
                                                          trainy, ...
                                                          '',...
                                                          GPModel.Options.do_rand_corrupt_hyp_ini);                               
                end
            end

            GPModel.kern.KFunc = @(X0, X1, kern_hyp) kern_sqexp(X0,...
                                                                X1,...
                                                                kern_hyp,...
                                                                []); 
                                                            
            GPModel.kern.diagKFunc = @(xx, nn, kern_hyp) ones(nn,1);

            GPModel.kern.dKFunc_dkernhyp = @(X0, X1, kern_hyp, dd, varargin) ...
                                                    dkern_sqexp_dp(X0, ...
                                                                   X1, ...
                                                                   kern_hyp, ...
                                                                   dd, ...
                                                                   varargin{:}); 
            GPModel.kern.extract_data_var = @(hyp) hyp(1);
            GPModel.kern.extract_noise_var = @(hyp) hyp(2);
            GPModel.kern.extract_kern_hyp = @(hyp) hyp(3:end); 
            GPModel.kern.pack_into_hyp = @(data_var, noise_var, kern_hyp) ...
                                            [data_var; noise_var; reshape(kern_hyp,[],1)];

            GPModel.kern.hyp_LB = GPModel.Options.pos_guard_bound * ones(size(GPModel.kern.hyp));
            GPModel.kern.hyp_UB = inf(size(GPModel.kern.hyp));

        otherwise

            error('Unsupported kernel');

    end
end

if ~isProperlySet(GPModel.Options, 'hyp0')
    GPModel.Options.hyp0 = GPModel.kern.hyp;
end

end