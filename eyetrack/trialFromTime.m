function [trialNum] = trialFromTime(trialStarts,timePoints)
% given a vector of trial start times, returns the trial number of a given
% timepoint - quick and efficient
 
for n = 1:length(timePoints)
    [~,trialNum(n)]=min(abs(trialStarts-timePoints(n)));
    % correct if timepoint is prior to the start of this trial
    if timePoints(n)<trialStarts(trialNum(n))
        trialNum(n) = trialNum(n)-1;
    end
end
