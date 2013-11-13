function [P, G, Q, R, Dadv, QGG, infoQ, infoR, D, usedInfoPInds] = cholQRPermuteUpdate(...
                                                                    size_params,...
                                                                    P, ...
                                                                    G, ...
                                                                    Q, ...
                                                                    R, ...
                                                                    Dadv, ...
                                                                    QGG,...
                                                                    infoQ,...
                                                                    infoR,...
                                                                    D, ...
                                                                    usedInfoPInds)
                                                                
assert(all(D>=0));
assert(all(Dadv>=0));

dst_ind = size_params.dst_ind;
src_ind = size_params.src_ind;
kbound = size_params.kbound;
n = size_params.n;
info_offset_ind = dst_ind - 1;

not_empty_usedInfoPInds =  ~isempty(usedInfoPInds);
not_empty_QGG =  ~isempty(QGG);
not_empty_infoQ = ~isempty(infoQ);
not_empty_infoR = ~isempty(infoR);
if dst_ind < src_ind
    for s=src_ind-1:-1:dst_ind
        % permute indices
        P([s s+1]) = P([s+1 s]);
        if not_empty_usedInfoPInds
            usedInfoPInds([s s+1]) = usedInfoPInds([s+1 s]);
        end
        
        Dadv([s s+1]) = Dadv([s+1 s]);
        D([s s+1]) = D([s+1 s]);
        G([s s+1], 1:kbound) = G([s+1 s], 1:kbound);
        Q([s s+1], 1:dst_ind-1) = Q([s+1 s], 1:dst_ind-1);
        
        if not_empty_QGG;
            QGG(:, [s s+1]) = QGG(:, [s+1 s]);
        end
        
        if not_empty_infoQ
            infoQ([s s+1],:) = infoQ([s+1 s], :);
        end
        
        % update decomposition
        [Q1,R1] = qr( G(s:s+1, s:s+1).');
        if any(diag(R1) < 0 )
            Q1 = -Q1;
        end
        G(s-1:n, s:s+1) = G(s-1:n, s:s+1) * Q1;
        G(s, s+1) = 0;
        
        if not_empty_infoR
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
        
%         R(1:src_ind-1, s:s+1) = R(1:src_ind, s:s+1) * Q1;
%         [Q2, R2] = qr( R(s:s+1, s:s+1) );
%         if any(diag(R2) < 0 )
%             Q2 = -Q2;
%         end
%         R(s:s+1, 1:kbound) = Q2.' * R(s:s+1, 1:kbound);
%         Q(s-1:end, s:s+1) = Q(s-1:end, s:s+1) * Q2;
%         Q(n+(s:s+1), 1:kbound) = Q1.'*Q(n+(s:s+1), 1:kbound);%this doesn't work unless the augmented portion of G is isotropic
%         R(s+1, s) = 0;
    end
end

[Q, R] = QROneStep(dst_ind, dst_ind, G(:,dst_ind), Q, R);

D(dst_ind+1:n) =  D(dst_ind+1:n) - G(dst_ind+1:n,dst_ind).^2;
D(dst_ind) = 0;
D(D<0) = 0;

assert(all(D>=0));
assert(all(Dadv>=0));