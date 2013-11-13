function [testyhat, testys2] = run_pred_step(kern, data_var, kern_hyp, sis, ...
                                             PredModel, trainx, testx, nt)
 
 
if strcmp(kern.type, 'histIntKern')
    testXCells = kern.cellDataPrepFunc(testx); 
    iXcells = kern.cellDataPrepFunc(trainx(sis,:));

    K_star = data_var * kern.KFunc(iXcells, testXCells, kern_hyp);

    K_starstar = data_var * kern.diagKFunc(testXCells, nt, kern_hyp);

elseif strcmp(kern.type, 'SQExpKern')


    K_star = data_var * kern.KFunc(trainx(sis,:), testx, kern_hyp);

    K_starstar = data_var * kern.diagKFunc(testx, nt, kern_hyp);
                                                

elseif strcmp(kern.type, 'preComputedKern')
    
    if iscell(testx)
        K_star = 0;
        K_starstar = 0;
        for jj = 1:length(testx)
            K_star = K_star + kern_hyp(jj)*testx{jj}.Knt(sis, :);
            K_starstar = K_starstar + kern_hyp(jj)*testx{jj}.Ktt;
        end
    else
        K_star = kern_hyp * testx.Knt(sis, :);
        K_starstar = kern_hyp * testx.Ktt;
    end
    
else
    error('unsupported');
end

[testyhat, testys2] = dtc_pred(K_star, K_starstar, PredModel, false);

testys2 = safeGuardPosValues(testys2); 
           

end