function K = compoundPreCompKsDiag(ws,xx)
K = 0;
for j = 1:length(ws)
    K = K + ws(j)*diag(xx{j});
end
end