function [delta_E, delta_EY, delta_EC, delta_Evar] = ...
                                     cholQRApproxUpdateCosts(size_params, ...
                                                             YP,...
                                                             D,...
                                                             G,...
                                                             Q,...
                                                             noise_var, ...
                                                             QGG, ...
                                                             infoR,...
                                                             do_var_cost)
                                                         
assert(all(D>=0));
DEBUG = false;

if ~exist('do_var_cost','var')
    do_var_cost = false;
end

k = size_params.k;
% delta = size_params.delta;
n = size_params.n;

info_inds = size_params.k:size_params.kadv;
YQ = YP(k:n).'*Q(k:n, 1:k-1);

if DEBUG && ~isempty(QGG)
    QGG_true = (Q(k:n, 1:k-1).'*G(k:n, info_inds))*G(k:n, info_inds).';
    [has_err] = test_matrix_same(QGG, QGG_true,'QGG');
    assert(~has_err);
else
    if nargin < 7 || isempty(QGG)
        QGG = (Q(k:n, 1:k-1).'*G(k:n, info_inds))*G(k:n, info_inds).';
    end
end

YGG = ((YP(k:n)).'*G(k:n, info_inds))*G(k:n, info_inds).' ;


if DEBUG && ~isempty(infoR)
    [~, infoR_true] = qr(G(1:n, info_inds), 0); 
    negPivots = diag(infoR_true) < 0;
    infoR_true(negPivots, :) = - infoR_true(negPivots, :);
    [has_err] = test_matrix_same(infoR,infoR_true,'infoR');
    assert(~has_err);
else
    if nargin < 8 || isempty(infoR)
        [~, infoR] =  qr(G(1:n, info_inds), 0); 
    end
end

ggs =  sum((G(k:n, info_inds) * infoR.').^2, 2).';

top = (YGG - YQ*QGG).^2; 
bottom = ggs + noise_var*D(k:n).' - sum(QGG.^2, 1);
bottom = safeGuardPosValues(bottom);

delta_EY = zeros(1,n);
delta_EY(k:n) = (top./bottom)/noise_var;

delta_EC = zeros(1,n);
delta_EC(k:n) = log(noise_var) - log(bottom) + log(D(k:n).');

if do_var_cost
    delta_Evar = zeros(1,n);
    delta_Evar(k:n) = (ggs./D(k:n).')./noise_var;
    delta_E = (delta_EY + delta_EC + delta_Evar)/2;
else
    delta_Evar = [];
    delta_E = (delta_EY + delta_EC)/2;
end

delta_E(1:(k-1)) = -inf;

end