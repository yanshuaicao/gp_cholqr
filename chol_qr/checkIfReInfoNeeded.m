function [needed, RIPParams] = checkIfReInfoNeeded(RIPParams,D,Dadv,Jmax,ik_swap,needed)
    if ~exist('needed', 'var')
        needed = false;
    end
    if isProperlySet(RIPParams, 'swap_info_pivots') && ~ RIPParams.swap_info_pivots
        needed = false;
    else
        if isProperlySet(RIPParams,'pre_schedule') 

            needed = any(RIPParams.pre_schedule == ik_swap); 

        elseif isProperlySet(RIPParams, 'RIP_count') && ...
               isProperlySet(RIPParams, 'max_num_info_revisit') && ...
               RIPParams.RIP_count > RIPParams.max_num_info_revisit

               needed = false;

%         elseif isProperlySet(RIPParams, 'd_ratio') 
% 
%                needed = needed || 1-(sum(Dadv)/sum(D)) < RIPParams.d_ratio;
% 
%         elseif isProperlySet(RIPParams,'reShuffleInfoPJmaxBound')   
% 
%                needed = needed || Jmax < RIPParams.reShuffleInfoPJmaxBound;
        end

        if needed && isProperlySet(RIPParams, 'RIP_count')
            RIPParams.RIP_count = RIPParams.RIP_count + 1;
        end
    end
end