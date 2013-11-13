function dK = dkern_sqexp_dp(x1,x2,invl,ind,K,fast_mode,pd_cache)
if nargin < 6
    fast_mode = false;
end
% if size(x1,2) == 1 && numel(invl) == 1
%     D = sq_dist(x1,x2);
%     K = exp(-D*invl/2);
%     dK = -.5*invl(ind).*K.*D;
% else
if ~isrow(invl)
    invl = invl.';
end
if nargin < 5 ||  isempty(K) 
    D = sq_dist(bsxfun(@times,x1,sqrt(invl)),bsxfun(@times,x2,sqrt(invl)));
    K = exp(-D./2);
end
if fast_mode %assumes -.5 is handled outside
    if nargin < 7 || isempty(pd_cache)
        dK = K.*(dist(x1(:,ind),x2(:,ind))).^2;
    else
        dK = K.*pd_cache;
    end
else
    %dK = -.5.*K.*sq_dist(x1(:,ind),x2(:,ind));
    dK = -.5.*K.*(dist(x1(:,ind),x2(:,ind))).^2;
end
% end
end