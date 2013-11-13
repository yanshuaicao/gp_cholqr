function name = shorten_name(name)
feature_name_dicts = [];
f_id = 0;
%%
f_id = f_id + 1;
feature_name_dicts(f_id).long_form = 'devRun';
feature_name_dicts(f_id).short_form = 'dev';
%%
f_id = f_id + 1;
feature_name_dicts(f_id).long_form = 'proRun';
feature_name_dicts(f_id).short_form = 'pro';
%%
f_id = f_id + 1;
feature_name_dicts(f_id).long_form = ' ';
feature_name_dicts(f_id).short_form = 'd';
%%
f_id = f_id + 1;
feature_name_dicts(f_id).long_form = 'nopInfoP';
feature_name_dicts(f_id).short_form = 'noP';
%%
f_id = f_id + 1;
feature_name_dicts(f_id).long_form = 'ReInfo';
feature_name_dicts(f_id).short_form = 'ReIn';
%%
f_id = f_id + 1;
feature_name_dicts(f_id).long_form = 'RandSwapOrder';
feature_name_dicts(f_id).short_form = 'RSwapO';
%%
f_id = f_id + 1;
feature_name_dicts(f_id).long_form = '_RandInfo_';
feature_name_dicts(f_id).short_form = '_RandIn_';
%%
f_id = f_id + 1;
feature_name_dicts(f_id).long_form = '_nonlinear-CG_';
feature_name_dicts(f_id).short_form = '_';
%%
f_id = f_id + 1;
feature_name_dicts(f_id).long_form = '-SQExpKern-';
feature_name_dicts(f_id).short_form = '-';
%%
f_id = f_id + 1;
feature_name_dicts(f_id).long_form = '-preComputedKern-';
feature_name_dicts(f_id).short_form = '-preComp-';
%%
f_id = f_id + 1;
feature_name_dicts(f_id).long_form = '-graph-';
feature_name_dicts(f_id).short_form = '-G-';
%%
f_id = f_id + 1;
feature_name_dicts(f_id).long_form = '___runJob-version-parent:';
feature_name_dicts(f_id).short_form = '_runJob-vp';
%%
f_id = f_id + 1;
feature_name_dicts(f_id).long_form = '-standardized-';
feature_name_dicts(f_id).short_form = '-S-';
%%
f_id = f_id + 1;
feature_name_dicts(f_id).long_form = 'gaussian';
feature_name_dicts(f_id).short_form = 'gauss';
%%
f_id = f_id + 1;
feature_name_dicts(f_id).long_form = 'uniform';
feature_name_dicts(f_id).short_form = 'unif';
%%
 
for ii = 1:length(feature_name_dicts)
    name = strrep(name,feature_name_dicts(ii).long_form,feature_name_dicts(ii).short_form);
end
end

