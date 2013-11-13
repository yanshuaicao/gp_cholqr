function [P, G, Q, R, Dadv, D, prevInfoPivots] = ...
                                        cholQRRevisitInfoPivots(size_params, ...
                                                                trainx,...
                                                                K,...
                                                                P, ...
                                                                G, ...
                                                                Q, ...
                                                                R, ...
                                                                Dadv, ...
                                                                noise_var, ...
                                                                D, ...    
                                                                prevInfoPivots,...
                                                                RIPParams)
                                                                
assert(~isempty(prevInfoPivots))                               
                                                             
k = size_params.k;
n = size_params.n;
old_kadv = size_params.kadv;
% delta = size_params.delta;
% m = size_params.m;
info_pivots_inds  = k:size_params.kadv;
% old_info_pivots = P(info_pivots_inds);
prevInfoPivots(info_pivots_inds) = true;
NP = length(info_pivots_inds);
    
 
Dadv(size_params.k:end) = Dadv(size_params.k:end) + ...
    sum(G(size_params.k:n,size_params.k:size_params.kadv).^2,2);

G(:,size_params.k:size_params.kadv) = 0;
Q(:,size_params.k:size_params.kadv) = 0;
R(size_params.k:size_params.kadv,size_params.k:size_params.kadv) = 0;
size_params.kadv = size_params.k - 1;
    
for p = 1:NP
        info_p = info_pivots_inds(p);
        size_params.kadv = size_params.kadv + 1;
        
       
        if all(prevInfoPivots(k:end))  
            %all the remaining ones have served as info pivots before, clear queue
            prevInfoPivots = false(size(P));
        end

        if isProperlySet(RIPParams,'use_rand_info') && RIPParams.use_rand_info
            scores = rand(size(Dadv));
            scores(1:k-1) = 0;
        else
            scores = Dadv;
            scores(prevInfoPivots) = 0;
        end

        
        [ik_best, D_ik_best] = getMaxInd(scores, info_p, Dadv, 1e-10);
        
        if  Dadv(ik_best) <= 1e-5
 
            prevInfoPivots = false(size(P));
 
            if isProperlySet(RIPParams,'use_rand_info') && RIPParams.use_rand_info
                scores = rand(size(Dadv));
                scores(1:k-1) = 0;
            else
                scores = Dadv;
                scores(prevInfoPivots) = 0;
            end
        
            [ik_best, D_ik_best] = getMaxInd(scores, info_p, Dadv, 1e-10);
        end
        
        size_params.ik_best = ik_best;
   

     
        [P, G, Dadv, D, prevInfoPivots, Q(:,1:size_params.k)] = cholOneStep(size_params.ik_best , ...
                                                        size_params.kadv,...
                                                        trainx,...
                                                        K, ...
                                                        P, ...
                                                        G, ...
                                                        Dadv, ...
                                                        noise_var,...
                                                        D, prevInfoPivots, Q(:,1:size_params.k));

        
 
end
    
%     info_inds = k:size_params.kadv;
%     if ~isempty(QGG)
%         QGG = (Q(k:n, 1:k-1).'*G(k:n, info_inds))*G(1:n, info_inds).';
%     end
%     if ~isempty(infoR)
%         [infoQ, infoR] =  qr(G(1:n, info_inds), 0); 
%         negPivots = diag(infoR) < 0;
%         infoR(negPivots, :) = - infoR(negPivots, :);
%         infoQ(:, negPivots) = - infoQ(:, negPivots);
%     end
%     [QGG, infoQ, infoR] = cacheValueBatchCompute(size_params, Q,G);

assert(size_params.kadv == old_kadv);



assert(all(D>=0));
assert(all(Dadv>=0));
end