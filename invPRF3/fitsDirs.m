function [saveName, dataName] = fitsDirs(session,avg,stim,thisROI,modelSuffix)
 if avg == 1
        dataName = ['data/' session '/' session '_avg_' thisROI '.mat'];
        saveName = ['fits/' session(1:2) '_avg/' stim '/' session '_avg_' thisROI '_' modelSuffix '.mat'];
    else dataName = ['data/' session '/' session '_' thisROI '.mat'];
        saveName = ['fits/' session '/' stim '/' session '_' thisROI '_' modelSuffix '.mat'];
    end
end

