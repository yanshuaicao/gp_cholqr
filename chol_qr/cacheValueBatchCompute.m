function [QGG, infoQ, infoR] = cacheValueBatchCompute(size_params, Q,G)
k = size_params.k;
kadv = size_params.kadv;
n = size_params.n;

info_inds = k:kadv;
QGG = (Q(1:n, 1:k-1).'*G(1:n, info_inds))*G(1:n, info_inds).';
[infoQ, infoR] =  qr(G(1:n, info_inds), 0); 
negPivots = diag(infoR) < 0;
infoR(negPivots, :) = - infoR(negPivots, :);
infoQ(:, negPivots) = - infoQ(:, negPivots);
end