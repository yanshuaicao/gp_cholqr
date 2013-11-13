function [nvf, dnvf, predModel]= nvf_fixedSIS_preComputedKern(hyp, ...
                                                                K, ...
                                                                Y, ...
                                                                PI, ...
                                                                do_var_cost)
%the stable "V" method (Seeger 2003; Foster 2009)
if ~exist('do_var_cost','var')
    do_var_cost = false;
end

if isrow(hyp)
    hyp = hyp.';
end


s2 = hyp(1);
ws = hyp(2:end);
wdim = length(ws);

if ~iscell(K)
    K = {K};
end

if iscell(K)
    n = size(K{1},1);
else
    n = size(K,1);
end

r = numel(PI);
eye_r = eye(r);
 
cKrr = 0;
cKrn = 0;
for jj = 1:wdim
    cKrr = cKrr + ws(jj).*K{jj}(PI,PI);
    cKrn = cKrn + ws(jj).*K{jj}(PI,:);
end
 
Lr = jitChol(cKrr,5,'lower');
V = Lr\(cKrn);
M = s2*eye_r + V*V.';
LM = jitChol(M,5,'lower');
B = LM\(V*Y);
datafit = (Y.'*Y - B.'*B)/s2;
nmll = 2*sum(log(diag(LM))) + (n-r)*log(s2) + datafit;
nmll = nmll/2;

 
%% extra term for the variational free energy
if do_var_cost
    
    diagKs = nan(size(ws.'));
    for jj = 1:length(ws)
        diagKs(jj) = sum(diag(K{jj})); 
    end
    
    tr_diff = diagKs*ws - sum(sum(V.^2));
    trvar = .5*(tr_diff)/s2;
    nvf = nmll + trvar;
else
    nvf = nmll;
end

%%

if nargout > 2
    predModel.LM =LM;
    predModel.Lr = Lr;
    predModel.s2 = s2;
    predModel.B = B;
end

if nargout > 1
    
    LMB = LM.'\B;
    y0 = Y -  V.'*LMB;
    Lt = Lr*LM;
    LrV = Lr.'\V;
    LrVVLr = LrV*LrV.';
    
    V = Lt.'\(LM\V); %should be B1, overwrites V
    b1 = Lr.'\LMB;
    b1t = b1.';
    invA= Lt.'\(Lt\eye_r);
    invM= LM.'\(LM\eye_r);
    diffInv = (Lr.'\(Lr\eye_r) - s2*invA);
 
    dnmll = nan(numel(hyp), 1);
    dnmll(1) =  .5*(s2*trace(invM) + n - r + LMB.'*LMB - datafit)/s2; %this is dnmll_ds2
    
    for d = 1:wdim
        dnmll(1+d) =  -.5*sum(sum(diffInv.*(K{d}(PI,PI)))) + sum(sum(V.*K{d}(PI,:))) ...
             - (b1t*(K{d}(PI,:)*y0))/s2 + .5*(b1t*(K{d}(PI,PI))*b1);
    end
    
    if do_var_cost
        dtrvar = nan(numel(hyp),1);
        dtrvar(1) = -.5*tr_diff./(s2.^2);
        for d = 1:length(ws)
            dtrvar(1+d) = .5*(diagKs(d) - (2*sum(sum((K{d}(PI,:)).*LrV)) - sum(sum((K{d}(PI,PI)).*LrVVLr))))/s2;
        end
        
    end
 
    if do_var_cost
        dnvf = dnmll + dtrvar;
    else
        dnvf = dnmll;
    end
end

end

