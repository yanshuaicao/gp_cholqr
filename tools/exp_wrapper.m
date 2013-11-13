function [f, df] = exp_wrapper(fun, lx, LB, transInds)

if nargin < 3 || isempty(LB)
    LB = true(size(lx));
end

if nargin < 4 || isempty(transInds)
    transInds = true(size(lx));
end

in_x =  lx;
in_x(transInds) = exp(lx(transInds)) + LB;

[f, def] = fun(in_x);

dlx = ones(size(lx));
dlx(transInds) = exp(lx(transInds));
dlx = reshape(dlx,size(def));
df = def.*dlx;

if isnan(f) || isinf(f) || any(isnan(df)) || any(isinf(df))
        error('Evaluation failed')
end

end