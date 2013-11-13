function Krc = KCompWrapper(Kfcn,getX,RI,CI,kern_hyp,pdcache)
if isempty(pdcache)
    Krc = Kfcn(getX(RI),getX(CI),kern_hyp);
else
    error('Not implemented yet')
end
end