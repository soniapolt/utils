function [dataName, fitsName] = fitsDirsSherlock(expt,session,stim,thisROI,modelSuffix)
    dataName = fullfile('data',expt,session,[session '_' thisROI '.mat']);
    fitsName = fullfile('fits',expt,session, stim,[session '_' thisROI '_' modelSuffix '.mat']);
end