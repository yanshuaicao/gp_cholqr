function [newhyp, done] = optimizeContHyperParams(funObj, hyp0, LB, UB, ...
                                                        nIter, methodName)
done = false;                                                    

switch methodName
   
    case 'nonlinear-CG'
        
            lhyp0 = log(hyp0 - LB);
            wrapped_funobj = @(xx) exp_wrapper(funObj, xx, LB);
            fprintf('calling minimize on %s with length %d\n', func2str(funObj), -abs(nIter));
            [newhyp, fX] = minimize(lhyp0, wrapped_funobj, -abs(nIter));
            newhyp = exp(newhyp) + LB;  
            done = isempty(fX);
 
    otherwise
            error('Unsupported optimization method %s', methodName);
end


end