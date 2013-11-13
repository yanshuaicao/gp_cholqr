function [nmll datafit complexity] = cholQR_nmll_from_factors(trainy, Q, R, noise_var, n, k)
datafit = -sum((trainy.'*Q(1:n,1:k-1)).^2)./noise_var;
complexity = (n-k+1)*log(noise_var) + 2*sum(log(abs(diag(R(1:k-1,1:k-1)))));
nmll = (datafit + complexity)/2;
end