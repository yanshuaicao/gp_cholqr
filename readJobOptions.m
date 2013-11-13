function OptInfo = readJobOptions(OptInfo, JobOptions)
% Read options from JobOptions and assign to OptInfo, override existing field in
% OptInfo of the same name only if the existing one is empty
    meltStruct(JobOptions);
    
    OptInfo = smartAssignVar(OptInfo, 'dataDir');
    OptInfo = smartAssignVar(OptInfo, 'resultDir', []);
    OptInfo = smartAssignVar(OptInfo, 'trainDataFname',[]);
    OptInfo = smartAssignVar(OptInfo, 'testDataFname',[]);
    OptInfo = smartAssignVar(OptInfo, 'dataSetName');

    OptInfo = smartAssignVar(OptInfo, 'hyp0', []);
    OptInfo = smartAssignVar(OptInfo, 'permanentID', []);
    OptInfo = smartAssignVar(OptInfo, 'snapshotID', []);
    OptInfo = smartAssignVar(OptInfo, 'm', []);
    
    OptInfo = smartAssignVar(OptInfo, 'nConPerStep', 20);
   
    OptInfo = smartAssignVar(OptInfo, 'delta', []);
    OptInfo = smartAssignVar(OptInfo, 'maxEpoch', 10);
    
    OptInfo = smartAssignVar(OptInfo,  'preComputedKern', []);
    OptInfo = smartAssignVar(OptInfo,  'kern', []);
    OptInfo = smartAssignVar(OptInfo,  'KFold', []);
    OptInfo = smartAssignVar(OptInfo,  'hypIniMethod', []);
    
    OptInfo.contHypOptMethodName = 'nonlinear-CG';
    
end