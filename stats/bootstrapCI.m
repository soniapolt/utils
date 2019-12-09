function [median,CI] =bootstrapCI(data,sizeSample,numSamples,CI)
% function [median,CI] =bootstrapCI(data,numSamples,CI)
% knk bootstrap code + confidence intervals
% default numSamples = 100, CI = 68%

if ~exist('sizeSamples','var') sizeSamples = length(data); end
if ~exist('numSamples','var') numSamples = 100; end
if ~exist('CI','var') CI = 68; end

bootstrap(data,@mean);


end

