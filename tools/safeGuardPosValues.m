function D = safeGuardPosValues(D, err_threshold, warn_threshold)
    if nargin < 3
        warn_threshold = 0;
    end
    if nargin < 2
        err_threshold = 1e-2;
    end
    
    assert(all(D >= -err_threshold));
    
    warn_inds = D < warn_threshold;
    
    if nnz(warn_inds) > 0
        warning('%d entries exceeded negative threshold',nnz(warn_inds));
        D(warn_inds) = 0;
    end
end