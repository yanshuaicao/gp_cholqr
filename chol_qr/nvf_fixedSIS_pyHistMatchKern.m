function [nvf, dnvf, predModel] = nvf_fixedSIS_pyHistMatchKern(hyp, kernMM, kernMN, Y, r, do_var_cost)
%implementation using the stable "V" method (Seeger 2003; Foster 2009)

if ~exist('do_var_cost','var')
    do_var_cost = false;
end

if isrow(hyp)
    hyp = hyp.';
end
 
s2 = hyp(1);
ws = hyp(2:end);
wdim = length(ws);
n = numel(Y);

eye_r = eye(r);
[Krr HIQrr]= kernMM(ws);
[Krn HIQrn]= kernMN(ws);
Lr = jitChol(Krr,5,'lower');
V = Lr\(Krn);
M = s2*eye_r + V*V.';
LM = jitChol(M,5,'lower');
B = LM\(V*Y);
datafit = (Y.'*Y - B.'*B)/s2;
nmll = 2*sum(log(diag(LM))) + (n-r)*log(s2)  + datafit;
 
nmll = nmll/2;

if do_var_cost
  
    trK = n; %% TODO: this is actually assuming stationary kernel, need to make it more flexible
    tr_diff = sum(ws)*trK - sum(sum(V.^2));
    trvar = .5*(tr_diff)/s2;
    nvf = nmll + trvar;
%    nvf = trvar;
else
    nvf = nmll;
end

if nargout > 2
    predModel.Lr = Lr;
    predModel.LM = LM;
    predModel.B = B;
    predModel.s2 = s2;
end

if nargout > 1
    dnmll = nan(numel(hyp),1);
    LMB = LM.'\B;
    y0 = Y -  V.'*LMB;
    Lt = Lr*LM;
    LrV = Lr.'\V;
    LrVVLr = LrV*LrV.';
    V = Lt.'\(LM\V); %should be B1, overwrites V
    b1 = Lr.'\LMB;
    invA= Lt.'\(Lt\eye_r);
    invM= LM.'\(LM\eye_r);
    diffInv = (Lr.'\(Lr\eye_r) - s2*invA);

    dnmll(1) =  .5*(s2*trace(invM) + n - r + LMB.'*LMB - datafit)/s2; %this is dnmll_ds2
    
   if do_var_cost
        dtrvar = nan(numel(hyp),1);
        dtrvar(1) = -.5*tr_diff./(s2.^2);
    end
   
    for d = 1:wdim
%         dKrr = c*dKfcn_dinvl(getX(PI),getX(PI),invl,d,pdcache);
%         dKrn = c*dKfcn_dinvl(getX(PI),getX(1:n),invl,d,pdcache);
        dnmll(1+d) = -.5*sum(sum(diffInv.*HIQrr(:,:,d))) + sum(sum(V.*HIQrn(:,:,d))) ...
             - (b1.'*(HIQrn(:,:,d)*y0))/s2 + .5*b1.'*HIQrr(:,:,d)*b1;
         
        if do_var_cost
        
            dtrvar(1+d) =   .5*(trK - (2*sum(sum(LrV.*HIQrn(:,:,d))) - ...
                                    sum(sum( HIQrr(:,:,d) .* LrVVLr))))/s2;
        end 
    end
    if do_var_cost
        dnvf = dnmll + dtrvar;
    else
        dnvf = dnmll;
    end
%     dnmll = dnmll +  2*(log(hyp)./hyp) + 2*hyp;
end

end
