function [k, kadv, P, G, Q, R, Dadv, QGG, infoQ, infoR, D, usedInfoPInds, pp_age] = ...
                                cholQRLowRankDowndate(  size_params,...
                                                        P, ...
                                                        G, ...
                                                        Q, ...
                                                        R, ...
                                                        Dadv, ...
                                                        QGG,...
                                                        infoQ,...
                                                        infoR,...
                                                        D, ...
                                                        usedInfoPInds,...
                                                        pp_age)
%precondition: we have already factored up to k-1 for main part, and for info part
%up to kadv
%postcondition: we have shifted pivot ik_down to position kadv, and nullified
%factor entries at that position; we now have factorization up to k-1 and kadv-1
% D(k:n) =  D(k:n) + G(k:n,ik_down).^2;

ik_down = size_params.ik_down; 
k = size_params.k;
kadv = size_params.kadv;
n = size_params.n;
 
assert(k <= kadv + 1);
info_offset_ind = k - 1;

not_empty_usedInfoPInds =  ~isempty(usedInfoPInds);
not_empty_pp_age = ~isempty(pp_age);

not_empty_QGG =  ~isempty(QGG);
not_empty_infoQ = ~isempty(infoQ);
not_empty_infoR = ~isempty(infoR);

if ik_down < kadv
    for s=ik_down:kadv-1
        if s == k-1
            deltaDsqrt = G(s:n, s);
           
            D(k-1) = deltaDsqrt(1).^2;
            if numel(deltaDsqrt) > 1
                D(k:n) =  D(k:n) + deltaDsqrt(2:end).^2;
            end
        
            if not_empty_infoQ
                [infoQ, infoR] = qrInsertToPos(infoQ, infoR, G(1:n,s), 1);
                info_offset_ind = info_offset_ind - 1;
            end
            
            if not_empty_QGG
                QGG(:,k-1:n) = QGG(:,k-1:n) + (Q(s:n, 1:k-1).'*G(s:n, s))*(G(k-1:n, s).');
            end
        end
        
        % permute indices
        P([s s+1]) = P([s+1 s]);
        if not_empty_usedInfoPInds
            usedInfoPInds([s s+1])=  usedInfoPInds([s+1 s]);
        end
        
        if not_empty_pp_age  
            if s < k - 1 %both s and s+1 are predictive pivots
               pp_age([s s+1]) = pp_age([s+1 s]);
            elseif s == k - 1 % s+1 is outside the first k-1, so not predictive pivots
               pp_age(s) = 0;
            end
        end
        
        Dadv([s s+1]) = Dadv([s+1 s]);
        D([s s+1]) = D([s+1 s]);
        G([s s+1], 1:kadv) = G([s+1 s], 1:kadv);
        Q([s s+1], 1:kadv) = Q([s+1 s], 1:kadv);
        if not_empty_QGG
            QGG(:, [s s+1]) = QGG(:, [s+1 s]);
        end
        
        if not_empty_infoQ
            infoQ([s s+1],:) = infoQ([s+1 s], :);
        end
        
        % update decomposition
        [Q1, R1] = qr( G(s:s+1, s:s+1).');
        
        if any(diag(R1) < 0 )
            Q1 = -Q1;
        end
        if s == 1
            G(1:n, s:s+1) = G(1:n, s:s+1) * Q1;
        else
            G(s-1:n, s:s+1) = G(s-1:n, s:s+1) * Q1;
        end
        G(s, s+1) = 0;

        if not_empty_infoR
            
            if s > k - 2
                
                infoR(:, (s:s+1)-info_offset_ind) = infoR(:,(s:s+1)-info_offset_ind) * Q1;

                [infoQ2, infoR2] = qr( infoR((s:s+1)-info_offset_ind, ...
                                             (s:s+1)-info_offset_ind) );

                if any(diag(infoR2) < 0 )
                    infoQ2 = -infoQ2;
                end

                infoR((s:s+1)-info_offset_ind, :) = infoQ2.' * infoR((s:s+1)-info_offset_ind, :);
                infoQ(:, (s:s+1)-info_offset_ind) = infoQ(:, (s:s+1)-info_offset_ind) * infoQ2;
                infoR((s+1)-info_offset_ind, s-info_offset_ind) = 0; 
                
            end
            
            if s == kadv - 1
                infoQ = infoQ(:,1:end-1);
                infoR = infoR(1:end-1,1:end-1);
            end
        end
        
        if s < k
            R(1:kadv, s:s+1) = R(1:kadv, s:s+1) * Q1;
            [Q2,R2] = qr( R(s:s+1, s:s+1) );

            if any(diag(R2) < 0 )
                Q2 = -Q2;
            end

            R(s:s+1,1:kadv) = Q2.' * R(s:s+1,1:kadv);
            Q(:,s:s+1) = Q(:,s:s+1) * Q2;
            Q(n+(s:s+1),1:kadv) = Q1.'*Q(n+(s:s+1),1:kadv); %this doesn't work unless the augmented portion of G is isotropic
            R(s+1,s) = 0;
        end
        
        if not_empty_QGG
            if s < k - 1
               QGG(s:s+1, k-1:n) = Q2.'* QGG(s:s+1, k-1:n);
            end

            if s == k - 1
               QGG(s,:) = [];
    %            QGG = QGG - (Q(s:n, 1:k-1).'*G(s:n, s))*(G(1:n, s).');
            end

            if s == kadv - 1
               if ik_down < k 
                QGG(:,k-1:n) = QGG(:,k-1:n) - (Q(s+1:n, 1:k-2).'*G(s+1:n, s+1))*(G(k-1:n, s+1).'); 
               else
                QGG(:,k-1:n) = QGG(:,k-1:n) - (Q(s+1:n, 1:k-1).'*G(s+1:n, s+1))*(G(k-1:n, s+1).'); 
               end
            end
        end
%       showGQR(G,Q,R);
    end
end

Dadv(kadv+1:n) =  Dadv(kadv+1:n) + G(kadv+1:n, kadv).^2;
Dadv(kadv) = G(kadv, kadv).^2;

if k == kadv + 1
    D(k-1) = G(k-1, k-1).^2;
end

G(:,kadv) = 0;
Q(:,kadv) = 0;
R(1:kadv, kadv) = 0;
R(kadv, 1:kadv) = 0;
kadv = kadv - 1;
if ik_down < k
    k = k - 1;
end

end