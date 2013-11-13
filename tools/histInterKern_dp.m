function dK = histInterKern_dp(histInternF,X1,X2,ws,d,Q)

if exist('Q','var') && ~isempty(Q)
    dK = Q(:,:,d);
else
    dK = histInternF(X1{d},X2{d});
end

end