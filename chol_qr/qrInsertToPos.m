function [Q,R] = qrInsertToPos(Q,R,g,j)
    k = size(R,2);
    newR = Q.'*g;
    newQ = g - Q*newR;
    newr = norm(newQ);
    newQ = newQ/newr;
    Q = [Q newQ];
    R = [R newR; zeros(1,k) newr];

    for s = k:-1:j

        R(:,[s s+1]) = R(:,[s+1 s]);
        [Q1,R1] = qr( R(s:s+1, s:s+1) );
        if any(diag(R1) < 0 )
            Q1 = -Q1;
        end

        R(s:s+1,s:end) = Q1.'*R(s:s+1,s:end);
        Q(:,s:s+1) = Q(:,s:s+1)*Q1;
    end
end