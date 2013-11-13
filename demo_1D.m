clear
close all

% Mostly excerpt from runJob() as script for easier interaction
%% Specify problem, and some important options
%data set info
JobOptions.dataDir = './Snelson_1D_data/';
JobOptions.dataSetName =  'snelson_1D';

trainx = importdata([JobOptions.dataDir 'train_inputs']);
trainy = importdata([JobOptions.dataDir 'train_outputs']);
testx = importdata([JobOptions.dataDir 'test_inputs']);

% to do the downsampled version, uncomment the next two lines
trainx = trainx(1:10:end);
trainy = trainy(1:10:end);

%model options
GPModel = 'cholqr';

OptInfo = struct('m',10, ... % number of inducing points
                'delta',5,... % number of info pivots 
                'max_swap_per_epoch',2); % number of discrete swaps per pass  

OptInfo.sis_ini_method = 'RAND';

% The next two options cause inducing points to be initialized to a tight
% cluster of points near a "valley" in the Snelson's 1D dataset;
% Comment out the next two lines to use less adversarial initialization of inducing points

OptInfo.sis_ini_method = 'CLUMPED-GIVEN-CENTRE';
OptInfo.CLUMPED_CENTRE_X = 1.5;

OptInfo.do_save_result = false;
OptInfo.r_seed = 0;

%for large problems, this could offer some speedup, at the cost of numerical
%stability 
OptInfo.use_cache = false; 

% true for using Titsias' variational objective, false for marginal likelihood
OptInfo.do_var_cost = true;
%% setups

OptInfo = readJobOptions(OptInfo, JobOptions);
OptInfo = smartAssignVar(OptInfo, 'r_seed', 0);
OptInfo.do_rand_corrupt_hyp_ini = false;

if  verLessThan('matlab', '7.12')
    rand('seed', OptInfo.r_seed);
    randn('seed',OptInfo.r_seed);
else
    rng(OptInfo.r_seed);
end

OptInfo = smartAssignVar(OptInfo, 'pos_guard_bound', 1e-10);
 
%to calculate standardized negative log prob
if exist('testy','var') && ~isempty(testy)
    OptInfo.snlp_starndard_const = fitMeanStdBaseModel(testy, trainy);
else
    OptInfo.snlp_starndard_const = [];
    testy = [];
end

OptInfo.n = numel(trainy);

% process GP model specific param setup
GPModel = gpModelSetup(GPModel, OptInfo);

% process kernel related stuff 
GPModel = gpKernSetup(GPModel, trainx, trainy);
 
% further process continuous hyperparameter optimization settings
[GPModel, trainx, trainy] = postSetupProcess(GPModel, trainx, trainy);

% Initialize OptState, struct storing intermediate state data used in algoritms
OptState = initializeOptState(GPModel);

% To report predition result after each epoch of training 
pred_func = [];
% if isempty(testy)
%     if iscell(testx)
%         nt = size(testx{1},1);
%     else
%         nt = size(testx,1);
%     end
% else
%     nt = numel(testy);
% end
% 
% pred_func = @(data_var, noise_var, kern_hyp, sis, PredModel, trainx)  ...
%                 pred_and_score(testx, testy, nt, ...
%                                GPModel.Options.snlp_starndard_const, GPModel.kern,  ...
%                                data_var, noise_var, kern_hyp, sis, PredModel, trainx);

% Initialize OptHist, struct storing history of all important experiment results
OptHist.snlp_hist = {};
OptHist.smse_hist = {};
OptHist.nmll_hist = {};
OptHist.comptime_hist = {};
OptHist.discretetime_hist = {};
OptHist.I_hist = {};
OptHist.hyp_hist = {};

%% The interesting stuffs happen here
[GPModel, OptHist, OptState, PredModel] = runOpt(GPModel, OptState, OptHist, ...
                                        trainx, trainy, pred_func);
%% plot results
[sis, data_var, noise_var, kern_hyp] = extract_current_params(OptState, GPModel);

 
[testyhat, testys2, snlp, smse] = predAndScore(testx, testy, ...
                                                 numel(testx), ...
                                                 GPModel.Options.snlp_starndard_const, ...
                                                 GPModel.kern,  ...
                                                 data_var, ...
                                                 noise_var, ...
                                                 kern_hyp, ...
                                                 sis, ...
                                                 PredModel, ...
                                                 trainx);
 
plotGPOneD(trainx, trainy, testx, testyhat, testys2 + noise_var, [], 1,...
        'Snelson''s 1D dataset', trainx(OptState.I,:), trainy(OptState.I,:), ...
        trainx(GPModel.I_ini), [], true);

