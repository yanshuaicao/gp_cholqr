function [delta_E, delta_EY, delta_EC, delta_Evar] = ...
                    cholQRFastExactUpdateCostForOnePivot(size_params, ...
                                                         YP,...
                                                         P,...
                                                         D,...
                                                         G,...
                                                         Q,...
                                                         noise_var, ...
                                                         K,...
                                                         trainx,...   
                                                         do_var_cost)
                                                                             
assert(all(D>=0));

if ~exist('do_var_cost','var')
    do_var_cost = false;
end

k = size_params.k;
ik_best = size_params.ik_best;
n = size_params.n;

g = K(P(1:n),P(ik_best),trainx) - G(1:n,1:k-1)*G(ik_best,1:k-1).';
g = g/sqrt(D(ik_best));

YQ = YP.'*Q(1:n, 1:k-1);
Qg = Q(1:n, 1:k-1).'*g;
Yg = YP.'*g;
ggs = g.'*g;
 
top = (Yg - YQ*Qg).^2; 
bottom = ggs - sum(Qg.^2);
bottom = safeGuardPosValues(bottom);

delta_EY = (top./bottom)/noise_var;

delta_EC = log(noise_var) - log(bottom);

if do_var_cost
    delta_Evar = ggs./noise_var;
    delta_E = (delta_EY + delta_EC + delta_Evar)/2;
else
    delta_Evar = [];
    delta_E = (delta_EY + delta_EC)/2;
end

end