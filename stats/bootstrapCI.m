function [med,CI,dist] = bootstrapCI(data,sizeSamples,numSamples,CI)
% function [median,CI] = bootstrapCI(data,numSamples,CI)
% knk bootstrap code + confidence intervals
% default numSamples = 100, CI = 68%

if ~exist('sizeSamples','var') || isempty(sizeSamples) sizeSamples = length(data); end
if ~exist('numSamples','var') || isempty(numSamples) numSamples = 100; end
if ~exist('CI','var') || isempty(CI) CI = 68; end

dist = bootstrap(data,@mean,sizeSamples,numSamples);

ordered = sort(dist);
CI = [prctile(ordered, 50-CI/2), prctile(ordered, 50+CI/2)];
med = prctile(ordered,50);
end

