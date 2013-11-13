function [sis, data_var, noise_var, kern_hyp] = extract_current_params(OptState, GPModel)

switch  GPModel.gp_name
    case 'cholqr'
         sis = OptState.I;
         data_var = GPModel.kern.extract_data_var(OptState.hyp);
         noise_var = GPModel.kern.extract_noise_var(OptState.hyp);
         kern_hyp = GPModel.kern.extract_kern_hyp(OptState.hyp); 
    otherwise
        error('unsupported')
end

end