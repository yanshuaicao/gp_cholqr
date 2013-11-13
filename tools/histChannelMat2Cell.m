function Xcells = histChannelMat2Cell(trainx, dset_name)
     
    if any(strfind(dset_name,'hog'))    
        Xcells = cell(3,1);
        for d = 1:3
            Xcells{d} = trainx(:,(d-1)*270+(1:270));
        end
        
    elseif any(strfind(dset_name,'slice'))
    
        
        Xcells = cell(2,1);
        
        Xcells{1} = trainx(:,1:240);
        Xcells{2} = trainx(:,241:384);
    else
        error('unsupported')
    end
        
end