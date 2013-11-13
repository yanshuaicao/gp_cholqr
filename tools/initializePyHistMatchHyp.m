function hyp = initializePyHistMatchHyp(~,trainy,hypIniMethod, dset_name, doRandCorrupt)
switch hypIniMethod
    case 'PyHistMatchKernIni'
        c =  var(trainy);
        s2 = c/4;
        
        if any(strfind(dset_name,'hog'))
        
                      w = (c/3)*ones(1,3);

        elseif any(strfind(dset_name,'slice'))
        
                      w = (c/2)*ones(1,2);

        else
            error('unsupported')
        end

        hyp = [s2 w];
    otherwise
        error('Not supported');
end

if doRandCorrupt
    hypRandRatio = -log(rand(size(hyp))); %exp(1) random variable
    hyp = hyp.*hypRandRatio;
end
end