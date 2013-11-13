function [G, Q, R, Dadv, D] = batchCholQR(K, P, k, kadv, sig)
    G = jitChol(K(P,P),3,'lower');
    G = G(:, 1:kadv);
    if nargin > 3 && ~isempty(sig)
        G = [G; sig*eye(kadv)]; 
    end
%     G(:, kadv+1:end) = 0;
    Dadv = diag(K(P, P)) - sum(G(1:numel(P), 1:kadv).^2, 2);
    D = diag(K(P, P)) - sum(G(1:numel(P), 1:k-1).^2, 2);
    [Q, R] = qr(G, 0);
    negPivots = diag(R) < 0;
    Q(:, negPivots) = - Q(:, negPivots);
    R(negPivots, :) = - R(negPivots, :);
end