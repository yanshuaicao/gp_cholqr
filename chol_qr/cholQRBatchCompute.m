function [G,Q,R,D,Dadv] = cholQRBatchCompute(size_params,...
                                            trainx,...
                                            K,...
                                            diagK,...
                                            P,...
                                            noise_var,...
                                            includeInfoP)
m = size_params.m;
n = size_params.n;

kadv = size_params.kadv;
k = size_params.k;

if includeInfoP
    max_rank = m;
else
    max_rank = m + size_params.delta;
end

G = zeros(n + max_rank, max_rank);
Q = zeros(n + max_rank, max_rank);
R = zeros(max_rank, max_rank);
% D = zeros(n,1);
% Dadv = zeros(n,1);

eye_r = eye(kadv);
% K = @(RI,CI) data_var*KCompWrapper(Kfcn, getX, RI, CI, kern_hyp, []);

if nargout > 1
    Krr = K(P(1:kadv), P(1:kadv), trainx);
    Krn = K(P(1:kadv), P, trainx);
    Lr = jitChol(Krr, 5, 'lower');
    G(1:n, 1:kadv) = (Lr \ Krn).';
    G(n + (1:kadv), 1:kadv) = sqrt(noise_var) * eye_r;
    [Q(:, 1:kadv), R(1:kadv, 1:kadv)] = qr(G(:, 1:kadv), 0);
    Dadv = diagK(P);
    D = diagK(P);

    Dadv = Dadv - sum(G(1:n, 1:kadv).^2, 2);
    Dadv(1:kadv) = 0;
    D = D - sum(G(1:n, 1:k-1).^2, 2);
    D(1:k-1) = 0;
    
    D = safeGuardPosValues(D);
    Dadv = safeGuardPosValues(Dadv);
    assert(all(D>=0));
    assert(all(Dadv>=0));
end
end