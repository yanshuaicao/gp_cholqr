function [nvf datafit complexity trvar] = cholQR_nvf_from_factors(diagK, G, trainy, Q, R, noise_var, n, k)

 [~, datafit, complexity] = cholQR_nmll_from_factors(trainy, Q, R, noise_var, n, k);
 trvar = sum(diagK - sum(G(1:n,1:k-1).^2,2))./noise_var;
 nvf = (datafit + complexity + trvar)/2;
 
end