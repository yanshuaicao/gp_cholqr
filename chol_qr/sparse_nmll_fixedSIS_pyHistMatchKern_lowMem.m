function [nmll dnmll,predModel]= sparse_nmll_fixedSIS_pyHistMatchKern_lowMem(hyp, ...
                                                                            Kfcn, ...
                                                                            dKfcn_dws, ...
                                                                            iXcell,...
                                                                            Xcell,...
                                                                            Y, ...
                                                                            r, ...
                                                                            n, ...
                                                                            mindiag, ...
                                                                            ~)
%implementation using the stable "V" method (Seeger 2003; Foster 2009)
if ~exist('mindiag','var') || isempty(mindiag)
    mindiag = 1e-10;
end

if isrow(hyp)
    hyp = hyp.';
end

s2 = hyp(1);
ws = hyp(2:end);
dim = length(ws);
 
eye_r = eye(r);
 
 
[Krr, Qrr] = Kfcn(iXcell, iXcell, ws); 
[Krn, Qrn] = Kfcn(iXcell, Xcell, ws);
 

Lr = jitChol(Krr,5,'lower');
V = Lr\(Krn);
M = s2*eye_r + V*V.';
LM = jitChol(M,5,'lower');
B = LM\(V*Y);
datafit = (Y.'*Y - B.'*B)/s2;
nmll = 2*sum(log(diag(LM))) + (n-r)*log(s2)  + datafit;
nmll = nmll/2;

if nargout > 2
    predModel.LM =LM;
    predModel.Lr = Lr;
    predModel.s2 = s2;
    predModel.B = B;
end

if nargout > 1
    dnmll = nan(numel(hyp),1);
    LMB = LM.'\B;
    y0 = Y -  V.'*LMB;
    Lt = Lr*LM;
    V = Lt.'\(LM\V); %should be B1, overwrites V
    b1 = Lr.'\LMB;
    b1t = b1.';
    invA= Lt.'\(Lt\eye_r);
    invM= LM.'\(LM\eye_r);
    diffInv = (Lr.'\(Lr\eye_r) - s2*invA);
 
    dnmll(1) =  .5*(s2*trace(invM) + n - r + LMB.'*LMB - datafit)/s2; %this is dnmll_ds2
    
    for d = 1:dim
 
        dKrr_noc =  dKfcn_dws(iXcell, iXcell, ws, d, Qrr);

        dKrn_noc = dKfcn_dws(iXcell, Xcell, ws, d, Qrn);
        
        bKy = b1t*(dKrn_noc*y0);
        dKrn_noc = V.*dKrn_noc; %force Matlab to not create new chunk of memory for the intermediary step
        dnmll(1+d) = -.5*sum(sum(diffInv.*dKrr_noc)) + sum(sum(dKrn_noc)) ...
                 -bKy/s2 + .5*(b1t*dKrr_noc*b1);


    end
 
 
end

end

