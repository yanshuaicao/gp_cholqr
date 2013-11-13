function [testyhat, testys2, snlp, smse] = predAndScore(testx, ...
                                                         testy, ...
                                                         nt, ...
                                                         snlp_starndard_const, ...
                                                         kern,  ...
                                                         data_var, ...
                                                         noise_var, ...
                                                         kern_hyp, ...
                                                         sis, ...
                                                         PredModel, ...
                                                         trainx)

[testyhat, testys2] = run_pred_step(kern, data_var, kern_hyp, sis, ...
                                        PredModel, trainx, testx, nt);
                                    
                          
if ~isempty(testy)
    snlp  = computeTestSNLP(testyhat, testys2, ...
                                     noise_var, testy, ...
                                     snlp_starndard_const);

    smse = computeTestSMSE( testyhat, testy);

else
    snlp = [];
    smse = [];
end

end