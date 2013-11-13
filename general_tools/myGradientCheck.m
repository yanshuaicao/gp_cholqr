function [fi,vi,f,g,fdGrad] = myGradientCheck(fn,x,f,g,dx)
    if nargin < 4 || isempty(f) || isempty(g)
        [f,g] = fn(x);
    end
    if nargin < 6
        dx = [];
    end

    fdGrad = computeFiniteDiff(fn,x,dx);
    fdGrad = reshape(fdGrad,size(g));

    gradErr = abs(fdGrad - g);
    nzfdGrad = abs(fdGrad) > 128*sqrt(eps);
    nzuserGrad = abs(g) > 128*sqrt(eps);
    gradErrPctFD = zeros(size(g));
    gradErrPctFD(nzfdGrad) = gradErr(nzfdGrad)./abs(fdGrad(nzfdGrad));
    gradErrPctUser = zeros(size(g));
    gradErrPctUser(nzuserGrad) = gradErr(nzuserGrad)./abs(g(nzuserGrad));
    avgGradErrPct = 0.5*(gradErrPctFD + gradErrPctUser);
%   [maxErrPct I] = max(avgGradErrPct(:));
    errGrads = avgGradErrPct > 0.05 & gradErr > 1e-6;
    errGradIs = find(errGrads);
%   warnGrads = avgGradErrPct > 0.01 & gradErr > 1e-5 & ~errGrads;
%   warnGradIs = find(warnGrads);

    if ~isempty(errGradIs)
        [fi,vi] = ind2sub([numel(f) length(x)],errGradIs);
        for i = 1:numel(f)
            cInds = find(fi == i);
            if ~isempty(cInds)
                D = full([reshape(vi(cInds),[],1), reshape(fdGrad(errGradIs(cInds)),[],1), reshape(g(errGradIs(cInds)),[],1), reshape(100*avgGradErrPct(errGradIs(cInds)),[],1), reshape(gradErr(errGradIs(cInds)),[],1), reshape(x(vi(cInds)),[],1)]);
                fprintf('Gradient Errors in f(%d):\n', i);
                fprintf('\t%d: fdGrad = %g, userGrad = %g, %%error = %g, abs error = %g, x = %g\n', D.');
            end
        end
    else
        fi = [];
        vi = [];
    end
end
