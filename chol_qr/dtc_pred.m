function [mf,vf] = dtc_pred(k_star, k_starstar, PredModel, fullcov)
l_star = PredModel.Lr \ k_star;
LM_star = PredModel.LM \ l_star;
mf = LM_star.' * PredModel.B;

if fullcov
    vf = k_starstar - l_star.' * l_star + PredModel.s2 * (LM_star.' * LM_star);
else
    if ~isvector(k_starstar)
        k_starstar = diag(k_starstar);
    end
    vf = (k_starstar - sum(l_star.^2, 1).' + PredModel.s2 * sum(LM_star.^2, 1).');
end
end