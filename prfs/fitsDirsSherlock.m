function [dataName, fitsName] = fitsDirsSherlock(expt,session,stim,thisROI,modelSuffix)
    dataName = fullfile('/scratch','users','sonia09','data',expt,session,[session '_' thisROI '.mat']);
    fitsName = fullfile('/scratch','users','sonia09','fits',expt,session, stim,[session '_' thisROI '_' modelSuffix '.mat']);
end