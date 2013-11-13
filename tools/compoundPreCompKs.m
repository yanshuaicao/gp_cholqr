function K = compoundPreCompKs(ws,RI,CI,xx)
K = 0;
for j = 1:length(ws)
    K = K + ws(j)*(xx{j}(RI,CI));
end
end