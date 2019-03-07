function [betas,chosenK,kSSE] = ridgeCV(response,predictors,kRange)
% SP 1/8/2015
% ridge regression, choosing K via a 10-fold crossvalidation to minimize
% MSE
% should run in parallel to speed things up

kSSE = zeros(size(kRange));
parfor i = 1:length(kRange)
    predfun = @(xtr,ytr,xtst) [ones(size(xtst,1),1) xtst]*ridge(ytr,xtr,kRange(i),0);
    kSSE(i) = crossval('mse',predictors,response,'predfun',predfun);
end
%figure; plot(kRange,kSSE,'o-');

[~,ind] = min(kSSE);
chosenK = kRange(ind);
betas = ridge(response, predictors, chosenK);
end