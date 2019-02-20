function [dataName, fitsName] = fitsDirs(projectDir,expt,session,stim,thisROI,modelSuffix,fitsSuffix)
dataName = fullfile(projectDir,'cssFit','data',expt,session,[session '_' thisROI '.mat']);
if ~exist('fitsSuffix','var')||isempty(fitsSuffix)
    fitsName = fullfile(projectDir,'cssFit','fits',expt,session, stim,[session '_' thisROI '_' modelSuffix '.mat']);
else
    fitsName = fullfile(projectDir,'cssFit',['fits' fitsSuffix],expt,session, stim,[session '_' thisROI '_' modelSuffix '.mat']);
end
end