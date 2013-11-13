function [max_ind, max_primary_score] = getMaxInd(primary_score, ...
                                                  k, ...
                                                  secondary_score, ...
                                                  secondary_threshold,  ...
                                                  max_num_trial)
if nargin < 2
    k = 1;
end

if nargin > 2
    if nargin < 4
        secondary_threshold = 1e-10;
    end
    if nargin < 5
        max_num_trial = 200;
    end
    
    num_trial = 0;
    success = false;
    while ~success && num_trial < max_num_trial
        num_trial = num_trial + 1;
        [max_ind, max_primary_score] = getMaxIndCore(primary_score, k);
        
        if secondary_score(max_ind) > secondary_threshold
            success = true;
        else
            primary_score(max_ind) = -inf;
        end
    end
    
    if ~success
        warning(sprintf('Failed to find max score that has secondary score greater than threshold within %d trials; use max secondary score instead', max_num_trial));
        [max_ind, max_primary_score] = getMaxIndCore(secondary_score,k);
    end
else
    [max_ind, max_primary_score] = getMaxIndCore(primary_score,k);
end

end

function [max_ind, max_val] = getMaxIndCore(score,k)
   [max_val, max_ind] = max(score(k:end));
    max_ind = max_ind + k - 1;
end