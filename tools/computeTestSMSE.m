function [smse sse] = computeTestSMSE(tyhat,testy)
ydiff = (tyhat - testy);
sse = (ydiff.^2)/var(testy);
smse = mean(sse);
end