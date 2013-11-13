function [Q, R] = QROneStep(new_pivot , kk, newg, Q, R)
                                      
%first pivot relevant quantities to kk+1
if kk ~= new_pivot
    Q([kk new_pivot], 1:kk-1) = Q([new_pivot kk], 1:kk-1);
end

% performs classical Graham-Schmidt QR
R(1:kk-1, kk) = Q(kk:end, 1:kk-1).' * newg(kk:end) ;
Q(:, kk) = newg  - Q(:, 1:kk-1) * R(1:kk-1, kk);
R(kk, kk) = norm(Q(:, kk));
Q(:, kk) = Q(:, kk) / R(kk, kk);
end