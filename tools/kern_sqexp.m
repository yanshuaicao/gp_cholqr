function [K] = kern_sqexp(x1, x2, invl, pdcache)
if ~isrow(invl)
    invl = invl.';
end
D = sq_dist(bsxfun(@times, x1, sqrt(invl)), bsxfun(@times, x2, sqrt(invl)));

K = exp(-D./2);
end