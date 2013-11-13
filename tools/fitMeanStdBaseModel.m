function SNLP_baseConst = fitMeanStdBaseModel(valY,trainY)
my = mean(trainY);
sy = var(trainY);
SNLP_baseConst = (mean((valY - my).^2/sy) + log(sy))/2;
end