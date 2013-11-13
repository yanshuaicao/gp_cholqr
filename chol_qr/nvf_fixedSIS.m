function [nvf, dnvf, predModel]= nvf_fixedSIS(hyp, ...
                                            diagKfcn,...
                                            Kfcn, ...
                                            dKfcn_dinvl, ...
                                            get_x, ...
                                            Y, ...
                                            PI, ...
                                            n, ...
                                            do_var_cost,...
                                            all_pd_cache)
%implementation using the stable "V" method (Seeger 2003; Foster 2009)
if ~exist('do_var_cost','var')
    do_var_cost = false;
end

if ~exist('all_pd_cache','var')
all_pd_cache = [];
end

if isrow(hyp)
    hyp = hyp.';
end

c = hyp(1);

s2 = hyp(2);
invl = hyp(3:end);
dim = length(invl);
 
r = numel(PI);
eye_r = eye(r);

if isa(get_x,'function_handle')
    Krr = Kfcn(get_x(PI),get_x(PI),invl); 
    Krn = Kfcn(get_x(PI),get_x(1:n),invl);
else
    Krr = Kfcn(get_x(PI,:),get_x(PI,:),invl); 
    Krn = Kfcn(get_x(PI,:),get_x(1:n,:),invl);
end

Lr = jitChol(c*Krr,5,'lower');
V = Lr\(c*Krn);
M = s2*eye_r + V*V.';
LM = jitChol(M,5,'lower');
B = LM\(V*Y);
datafit = (Y.'*Y - B.'*B)/s2;
nmll = 2*sum(log(diag(LM))) + (n-r)*log(s2) + datafit;
nmll = nmll/2;
 
%% extra term for the variational free energy
if do_var_cost
    % TODO: next line actually assumes stationary kernel, need to make it more flexible
    trK = sum(diagKfcn([],n,[])); 
    tr_diff = c.*trK - sum(sum(V.^2));
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
 
    dnmll = nan(numel(hyp),1);
    dnmll(1) = -.5*r/c + .5*s2*sum(sum(invA.*Krr)) + sum(sum(V.*Krn)) ...
         - (b1t*Krn*y0)/s2 + .5*(b1t*Krr*b1);
     
    dnmll(2) =  .5*(s2*trace(invM) + n - r + LMB.'*LMB - datafit)/s2; %this is dnmll_ds2

    if do_var_cost
        dtrvar = nan(numel(hyp),1);
        dtrvar(1) = .5*(trK - (2*sum(sum(Krn.*LrV)) - sum(sum(Krr.*LrVVLr))))/s2;
        dtrvar(2) = -.5*tr_diff./(s2.^2);
    end
    
    if isa(get_x,'function_handle')
        x_sis = get_x(PI);
    else
        x_sis = get_x(PI,:);
    end
    temp = zeros(size(V)); % force matlab to use this buffer
    for d = 1:dim
        
        if isempty(all_pd_cache)
            dKrr_noc = dKfcn_dinvl(x_sis, x_sis, invl, d, Krr,true);
        elseif isa(all_pd_cache  ,'function_handle')
            pd_rr = all_pd_cache('rr',d);
            dKrr_noc = dKfcn_dinvl(x_sis, x_sis, invl, d, Krr,true, pd_rr);
        else
            dKrr_noc = dKfcn_dinvl(x_sis, x_sis, invl, d, Krr,true, all_pd_cache(d).rr);
        end
        
        if isempty(all_pd_cache)
            dKrn_noc = dKfcn_dinvl(x_sis, get_x(1:n), invl, d, Krn, true);
        elseif isa(all_pd_cache ,'function_handle')
            pd_rn = all_pd_cache('rn',d);
            dKrn_noc = dKfcn_dinvl(x_sis, get_x(1:n), invl, d, Krn, true, pd_rn);
        else
            dKrn_noc = dKfcn_dinvl(x_sis, get_x, invl, d, Krn, true, all_pd_cache(d).rn);
        end
        
        temp = V.*dKrn_noc;
        dnmll(2+d) = -.5*(-.5)*c*sum(sum(diffInv.*dKrr_noc)) + (-.5)*c*sum(sum(temp))  ...
                     - (-.5)*c*(b1.'*(dKrn_noc*y0))/s2 + (.5*(-.5)*c)*(b1.'*dKrr_noc*b1);
        
        if do_var_cost
            temp = LrV.*dKrn_noc;
            dtrvar(2+d) = - .5*(2*(-.5)*c*sum(sum(temp)) - ...
                                    (-.5)*c*sum(sum( dKrr_noc .* LrVVLr)))/s2;
        end
    end
    
    if exist('hyp_prior_w','var') && ~isempty(hyp_prior_w)
        dpenalty_dhyp = zeros(numel(hyp),1);
    %     dpenalty_dhyp(1) = hyp_prior_w*r*(2*(1./hyp(1))./(-hyp(1).^2) + 2*hyp(1));
        dpenalty_dhyp(1) =  - hyp_prior_w*((-alpha-1)/c + (beta*c.^(-2)));
        dnmll = dnmll + dpenalty_dhyp;
    end
 
    if do_var_cost
        dnvf = dnmll + dtrvar;
    else
        dnvf = dnmll;
    end
end

end

