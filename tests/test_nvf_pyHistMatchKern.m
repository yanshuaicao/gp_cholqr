function test_nvf_pyHistMatchKern()
%datadir = '/u/g8acai/gp_nips2012_data_results/data/preprocessed/';
train_data_fname = 'hog-pyramidone-traindata';
load(train_data_fname);
dim = 3;
N = size(trainx,1);
m = 50;
rInds = randperm(N);

for d = 1:dim
    Xcells{d} = trainx(:,(d-1)*270+(1:270));
end

%%
hyp0 = [.5 rand(1,3)];
[~,Q] = histInterKern(@hist_isect_c,Xcells,Xcells,hyp0(2:end));
%%
kernMM = @(ww) histInterKern(@hist_isect_c,[],[],ww,Q(rInds(1:m),rInds(1:m),:));
kernMN = @(ww) histInterKern(@hist_isect_c,[],[],ww,Q(rInds(1:m),:,:));
 

f = @(hh) nvf_fixedSIS_pyHistMatchKern(hh, kernMM,kernMN,trainy,m,true);
fprintf('Checking grad of  nvf_fixedSIS_pyHistMatchKern ...')
myGradientCheck(f,hyp0);
fprintf('.')
for i = 1:10
    hyp2 = hyp0.*rand(size(hyp0));
    myGradientCheck(f,hyp2);
    fprintf('.')
end
fprintf('done\n');

% [~,~,Q] =   full_nmll_pyHistMatchKern(hyp0,kernF,Xcells,trainy(1:N),N,1e-9);
% f2 = @(hh) full_nmll_pyHistMatchKern(hh,@hist_isect_c,Xcells,trainy(1:N),N,1e-9,Q);
% fprintf('Checking grad of full_nmll_pyHistMatchKern...')
% myGradientCheck(f2,hyp0);
%  fprintf('.')
% for i = 1:10
%     hyp2 = hyp0.*rand(size(hyp0));
%     myGradientCheck(f2,hyp2);
%     fprintf('.')
% end
% fprintf('done\n');
% 
% N = 7709;
% [~,~,Q] =   full_nmll_pyHistMatchKern(hyp0,@hist_isect_c,Xcells,trainy(1:N),N,1e-9);
% f3 = @(hh) full_nmll_pyHistMatchKern(hh,@hist_isect_c,Xcells,trainy(1:N),N,1e-9,Q);
% fprintf('Speed testing full_nmll_pyHistMatchKern...')
%  tic;
%  fprintf('.')
% for i = 1:10
%     hyp2 = hyp0.*rand(size(hyp0));
%     [fv,dfv] = f3(hyp2);
%     fprintf('.')
% end
% fprintf('done\n');
% toc;
end