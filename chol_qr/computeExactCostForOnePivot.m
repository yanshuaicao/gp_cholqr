function [trueTotalCost,trueYCost,trueCCost,trueVarCost,numericalErrLarge] = ...
            computeExactCostForOnePivot(trainx, diagK, K, P, Y, Dadv, G, s2, k, kinfo, pivot, ...
                                        MIN_DIAG, doWarning, doVerifyNumStab, do_var_cost)

if ~exist('doVerifyNumStab','var') || isempty(doVerifyNumStab)
    doVerifyNumStab  = false;
end

if  ~exist('MIN_DIAG','var') || isempty(MIN_DIAG)
    MIN_DIAG = 1e-13;
end

if  ~exist('do_var_cost','var') || isempty(do_var_cost)
    do_var_cost = false;
end

n = numel(P);
numericalErrLarge = false;
if pivot > kinfo
    if Dadv(pivot) < MIN_DIAG
        %won't be able to factorize with this one
        trueYCost = inf;
        trueCCost = inf;
        trueVarCost = inf;
        trueTotalCost =  -inf;
        return;
    end
    kk = kinfo+1;
    %the selected pivot is not among the look ahead ones
    P( [kk pivot] )        = P( [pivot kk] );
    %                 Y( [kk pivot] )        = Y( [pivot kk] );
    Dadv( [kk pivot] )        = Dadv( [pivot kk] );
    G( [kk pivot], 1:kk-1) = G( [pivot kk], 1:kk-1);
    
    % compute new Cholesky column
    G(kk, kk) = Dadv(kk);
    G(kk, kk) = sqrt(G(kk,kk));
    newKcol_DB = K(P(kk+1:n),P(kk),trainx);
    G(kk+1:n,kk)=1/G(kk,kk)*( newKcol_DB - G(kk+1:n,1:kk-1)*(G(kk,1:kk-1)).');
    q = kinfo + 1;
else
    kk = kinfo;
    q = pivot;
end
p = k;

if p < q
    for s=q-1:-1:p
        % permute indices
        P([s s+1]) = P([s+1 s]);
        G([s  s+1], 1:kk)=G([s+1 s], 1:kk);
        
        % update decomposition
        [Q1, ~] = qr2(G(s:s+1,s:s+1).');
        G(1:n, s:s+1) = G(1:n,s:s+1) * Q1;
        G(s, s+1)=0;
    end
end

trueYCost = -(Y(P).'*(G(1:n,1:k)*((G(1:n,1:k).'*G(1:n,1:k) + s2*eye(k))\G(1:n,1:k).'))*Y(P))/s2;
trueCCost = log(det(G(1:n,1:k).'*G(1:n,1:k) + s2*eye(k))) + (n-k)*log(s2);

if do_var_cost
    trueVarCost = sum(diagK(P) - sum(G(1:n,1:k).^2,2))./s2;
else
    trueVarCost = [];
end

if doVerifyNumStab
    %% verify numerical stability of cost computation
    [U_DB,S_DB] = svd(G(1:n,1:k),0); %SVD decomp for the rank-k G part
    S_DB = diag(S_DB);
    Lam_DB = (S_DB.^2)./(S_DB.^2+s2);
    yU_DB = Y(P).'*U_DB;
    JY_DB2  = - ((yU_DB.*(Lam_DB.'))*yU_DB.')/s2;
    JC_DB2 = sum(log((S_DB.^2 + s2))) + (n-k)*log(s2);
    if (abs(JY_DB2-trueYCost) > 1e-10 || abs(JC_DB2-trueCCost) > 1e-10)...
            && doWarning
        numericalErrLarge = true;
        warning('computeExactCostForOnePivot:NumericalInstability',...
            'numerical error in computing cost is large');
    end
else
    numericalErrLarge = false;
end

if do_var_cost
    trueTotalCost = (trueYCost + trueCCost + trueVarCost)/2;
else
    trueTotalCost = (trueYCost + trueCCost)/2;
end

end
