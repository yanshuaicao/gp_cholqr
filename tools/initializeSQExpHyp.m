function [hyp,c,s2,invl] = initializeSQExpHyp(trainx,trainy,methodName,doRandCorrupt)
if nargin < 3
    methodName = '';
end

switch methodName
    case {'UnitIniScale', 'UnitScale', 'useUnitIniScale'}
        c =  var(trainy);
        s2 = c/4;
        invl = ones(1,size(trainx,2));
    case 'DimWiseSTD'
        c =  var(trainy);
        s2 = c/4;
        invl =  1./(var(trainx)/10);
        invl(isnan(invl)) = 1;
        invl(isinf(invl)) = 1;
        invl = invl./size(trainx,2);
    otherwise
        c =  var(trainy);
        s2 = c/4;
        %invl =  1./((max(trainx)-min(trainx))/5).^2;
        rr  = (max(trainx)-min(trainx));
        rr(isnan(rr)) = 1;
        rr(isinf(rr)) = 1;
        rr(rr == 0) = 1;
        
        ppv = (prod(rr)/numel(trainy)).^(1/3);
        invl = exp(-(log(ppv).*(rr./sum(rr))));
        invl = reshape(invl,[],1);
       
end

hyp = [c ; s2 ;invl];
if doRandCorrupt
    hypRandRatio = -log(rand(size(hyp))); %exp(1) random variable
    hyp = hyp.*hypRandRatio;
end

end
