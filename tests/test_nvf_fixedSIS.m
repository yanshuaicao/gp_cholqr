function test_nvf_fixedSIS()
n = 30; %number of datapoints
dim = 1; %dimensionality of each x point
numC = 5; %number of cluster of x points
s2 = 1; % variance of additive noise for y
cstd = 10; %range param for cluster centers 
istd = 4;  %std for x datapoints given cluster center
fcn = @(xx) (sum(xx,2)); %mapping from x to y
invl = ones(1,dim);
invl = invl/(dim/numel(invl));
m = 5;

x = zeros(n,dim);

for i = 1:numC
    cc = cstd*(rand(1,dim)-.5);
    x((i-1)*(n/numC)+(1:(n/numC)),:) = bsxfun(@plus,cc, istd*randn(n/numC,dim)); 
end
 
y = fcn(x) + sqrt(s2)*randn(n,1);
c = std(y);
hyp =[c log(s2) invl];
getX = @(inds) x(inds,:);
% getX = x;
rp = randperm(n);
PI = rp(1:m);
all_pd_cache = prepare_all_pd_cache(x,PI);
kf = @(invll) test_kern_wrapper(@kern_sqexp,@dkern_sqexp_dp,x(PI,:),x(1:n,:),invll);
fprintf('checking grad for kernel gradients...')
myGradientCheck(kf,invl);
fprintf('done\n');



KFunc = @(X0, X1, kern_hyp) kern_sqexp(X0,...
                                        X1,...
                                        kern_hyp,...
                                        []);

diagKFunc = @(xx,nn,kern_hyp) ones(nn,1);

dKFunc_dkernhyp = @(X0, X1, kern_hyp, dd, varargin) ...
                                        dkern_sqexp_dp(X0, ...
                                        X1, ...
                                        kern_hyp, ...
                                        dd, ...
                                        varargin{:});
                                    
fprintf('checking grad for nvf_fixedSIS.')

for i = 1:5
    x = zeros(n,dim);

    for j = 1:numC
        cc = cstd*(rand(1,dim)-.5);
        x((j-1)*(n/numC)+(1:(n/numC)),:) = bsxfun(@plus,cc, istd*randn(n/numC,dim)); 
    end

    y = fcn(x) + sqrt(s2)*randn(n,1);
    c = std(y);
    
    
    rp = randperm(n);
    PI = rp(1:m);
    mindiag = 1e-14;
    hyp_p_w =rand(1);
    all_pd_cache = prepare_all_pd_cache(x,PI);
    getX = @(inds) x(inds,:);
    f = @(hh) nvf_fixedSIS(hh, diagKFunc, KFunc, dKFunc_dkernhyp, getX, y, PI, n, true, all_pd_cache);

    if i == 1
        hyp =[c s2 invl];
    else
        hyp = [2*rand(1) 1*rand(1) 1/20*rand(1,dim)];
    end

myGradientCheck(f,hyp);
fprintf('.')
end
fprintf('done\n');



% %%
% load slicelocaldetrend-standardized-traindata;
% % getX = @(IND)trainx(IND,:);
% [n d]= size(trainx);
% PI = randperm(n);
% m = 200;
% PI = PI(1:m);
% hyp = rand(d+2,1);
% f = @(hh) sparse_nmll_fixedSIS(hh,KFunc,dKFunc_dkernhyp,trainx,trainy,PI,n,mindiag,[]);
% % 
% % fprintf('checking grad for sparse_nmll_fixedSIS on slicelocal data.')
% % myGradientCheck(f,hyp);
% 
% fprintf('done\n');
%
% profile on;
% for i = 1:1
%     [v,dv] =f(rand(d+2,1));
% end
% profile viewer






end

function [k dk] = test_kern_wrapper(kernfcn,dkernfcn,x1,x2,invl)
k = kernfcn(x1,x2,invl,[]);
k = k(:);
for i = 1:length(invl)
%tmp = dkernfcn(x1,x2,invl,i,[]);
tmp = dkernfcn(x1,x2,invl,i,[],false );
dk(:,i) = tmp(:);
end
end