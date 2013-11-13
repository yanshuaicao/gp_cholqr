function [snlp snlp_pp] = computeTestSNLP(tyhat,tys2,noiseS2,testy,standardConst)
assert(all(tys2>=0));
assert(noiseS2 >= 0);
ydiff = (tyhat - testy);
tots2 = tys2 + noiseS2;
snlp_pp = (ydiff.^2./tots2 + log(tots2))/2 - standardConst;
snlp = mean(snlp_pp);
end