function [P, G, Q, R, DD, QGG, infoQ, infoR, varargout] = cholQROneStep(   ...
                                                                    new_pivot , ...
                                                                    k,...
                                                                    kadv, ...
                                                                    K, ...
                                                                    P, ...
                                                                    G, ...
                                                                    Q, ...
                                                                    R, ...
                                                                    DD, ...
                                                                    QGG, ...
                                                                    infoQ, ...
                                                                    infoR, ...
                                                                    noise_var,...
                                                                    varargin)
                                      
%Chol factorize with pivot ik_new, at position kadv, and factorize the new col to 
%obtain new column for Q and R via classical Graham-Schmidt
assert(all(DD >= 0));
% assert(size(info_R,1) == size(info_R,2));
n = numel(P);

%first pivot relevant quantities to kadv+1
 
P([kadv new_pivot]) = P([new_pivot kadv]);

for i = 1:length(varargin)
    varargout{i} = varargin{i};
    if ~isempty(varargout{i})
        varargout{i}([kadv new_pivot]) = varargout{i}([new_pivot kadv]);
    end
end

DD([kadv new_pivot]) = DD([new_pivot kadv]);
G([kadv new_pivot], 1:kadv-1) = G([new_pivot kadv], 1:kadv-1);
Q([kadv new_pivot], 1:kadv-1) = Q([new_pivot kadv], 1:kadv-1);

if ~isempty(QGG)
    QGG(:, [kadv new_pivot]) = QGG(:, [new_pivot kadv]);
end

if ~isempty(infoQ)
    infoQ([kadv new_pivot], :) = infoQ([new_pivot kadv], :);
end

% compute new Cholesky column
assert(DD(kadv) > 0);
G(kadv, kadv) = sqrt(DD(kadv));
newKcol = K(P(kadv+1:n), P(kadv));
G(kadv+1:n, kadv) =  1 / G(kadv, kadv) * ...
                    (newKcol - G(kadv+1:n, 1:kadv-1)*(G(kadv, 1:kadv-1)).');
if ~isempty(QGG)
    Qg = (Q(kadv:n, 1:k-1).'*G(kadv:n, kadv));                  
    QGG = QGG + Qg*G(1:n, kadv).';
end 

if ~isempty(infoR)
    info_r = infoQ(kadv:n, :).' * G(kadv:n, kadv);
    newQ = G(1:n, kadv) - infoQ(1:n, :) * info_r;
    info_rn = norm(newQ);
    newQ = newQ / info_rn;
    infoR = [infoR info_r; zeros(1, size(infoR,2)) info_rn];
    infoQ = [infoQ newQ];
end

if ~isempty(noise_var)
    G(n+kadv, kadv) = sqrt(noise_var);
end

% update diagonal
DD(kadv+1:n) =  DD(kadv+1:n) - G(kadv+1:n, kadv).^2;
DD(kadv) = 0;

% performs classical Graham-Schmidt QR
% Gcol = G(:, kadv);
R(1:kadv-1, kadv) = Q(kadv:end, 1:kadv-1).' * G(kadv:end, kadv) ;
Q(kadv:end, kadv) = G(kadv:end, kadv) - Q(kadv:end, 1:kadv-1) * R(1:kadv-1, kadv);
R(kadv, kadv) = norm(Q(kadv:end, kadv));
Q(kadv:end, kadv) = Q(kadv:end, kadv) / R(kadv, kadv);

% DD = safeGuardPosValues(DD);
assert(all(DD >= 0));
end