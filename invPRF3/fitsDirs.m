function [dataName, fitsName] = fitsDirs(projectDir,expt,session,stim,thisROI,modelSuffix)
    dataName = fullfile(projectDir,'cssFit','data',expt,session,[session '_' thisROI '.mat']);
    fitsName = fullfile(projectDir,'cssFit','fits',expt,session, stim,[session '_' thisROI '_' modelSuffix '.mat']);
end