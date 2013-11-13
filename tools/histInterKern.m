function [K Q] = histInterKern(histInternF,X1,X2,ws,Q)
dim = numel(ws);

if nargin < 5 || isempty(Q)
    n  = size(X1{1}, 1);
    m  = size(X2{1}, 1);
    
    Q = zeros(n, m, dim);
    
    for d = 1:dim
        Q(:,:,d) = histInternF(X1{d},X2{d});
    end
end

K = sum(bsxfun(@times, Q, reshape(ws,[1 1 dim])), 3);
end