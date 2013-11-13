function [GPModel, OptHist, OptState] = runJob(JobOptions, GPModel, do_save_result, r_seed, Options)    
if ~exist('Options','var')
    Options = [];
end
Options.entry_tic = tic;
%% input arguments and options related
Options = readJobOptions(Options, JobOptions);
Options = smartAssignVar(Options, 'r_seed', 0);
Options.do_rand_corrupt_hyp_ini = Options.r_seed ~= 0;

if  verLessThan('matlab', '7.12')
    rand('seed', Options.r_seed);
    randn('seed',Options.r_seed);
else
    rng(Options.r_seed);
end

% Options = smartAssignVar(Options, 'is_official_run', true);
Options = smartAssignVar(Options, 'do_save_result', true);
Options = smartAssignVar(Options, 'expiration_time', inf);
Options = smartAssignVar(Options, 'sis_ini_method', 'RAND');
Options = smartAssignVar(Options, 'do_var_cost', false);
Options = smartAssignVar(Options, 'pos_guard_bound', 1e-10);

% raw data related
[trainx, trainy, testx, testy] = readData(Options);

if exist('testy','var') && ~isempty(testy)
    Options.snlp_starndard_const = fitMeanStdBaseModel(testy, trainy);
else
    Options.snlp_starndard_const = [];
    testy = [];
end

Options.n = numel(trainy);

% process GP model specific param setup
GPModel = gpModelSetup(GPModel, Options);

% process kernel related stuff 
GPModel = gpKernSetup(GPModel, trainx, trainy);
 
% further process continuous hyperparameter optimization settings
[GPModel, trainx, trainy] = postSetupProcess(GPModel, trainx, trainy);

if isempty(testy)
    if iscell(testx)
        nt = size(testx{1},1);
    else
        nt = size(testx,1);
    end
else
    nt = numel(testy);
end

pred_func = @(data_var, noise_var, kern_hyp, sis, PredModel, trainx)  ...
                predAndScore(testx, testy, nt, ...
                               GPModel.Options.snlp_starndard_const, GPModel.kern,  ...
                               data_var, noise_var, kern_hyp, sis, PredModel, trainx);

%% 
fn_structdisp(GPModel);
%% Initialize OptHist, struct storing history of all important experiment results
OptHist.snlp_hist = {};
OptHist.smse_hist = {};
OptHist.nmll_hist = {};
OptHist.comptime_hist = {};
OptHist.discretetime_hist = {};
OptHist.I_hist = {};
OptHist.hyp_hist = {};

%% Initialize OptState, struct storing intermediate state data used in algoritms
OptState = initializeOptState(GPModel);

% make sure we can save
if GPModel.Options.do_save_result
    while ~save_runJob_results(GPModel, OptHist)
    end;
end
%% This is a hack
% if isProperlySet(Options,'estimate_rejection_rates')
%     GPModel.cholqr.estimate_rejection_rates = Options.estimate_rejection_rates;
%     global proposed_i proposed_j is_accepted
%     proposed_i = [];
%     proposed_j = [];
%     is_accepted = [];
% end

 
%%
OptHist.setup_time = toc(GPModel.Options.entry_tic);

[GPModel, OptHist, OptState] = runOpt(GPModel, OptState, OptHist, ...
                                      trainx, trainy, pred_func);

fprintf('done\n');
end

function [trainx, trainy, testx, testy] = readData(Options)
 
    cachedload([Options.dataDir Options.trainDataFname]);
    cachedload([Options.dataDir Options.testDataFname]);
    
    if ~exist('testy', 'var')
        testy = [];
    end

end