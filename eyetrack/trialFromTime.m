function [trialNum] = trialFromTime(trialStarts,trialEnds,timePoints)
% given a vector of trial start times, returns the trial number of a given
% timepoint - quick and efficient
 
for n = 1:length(timePoints)
    if timePoints(n)<trialStarts(1)
        trialNum(n) = 0;
    else
    [~,trialNum(n)]=min(abs(trialStarts-timePoints(n)));
    % correct if timepoint is prior to the start of this trial
    if timePoints(n)<trialStarts(trialNum(n)) 
        trialNum(n) = trialNum(n)-1;
    end
    % correct if timepoint is in the driftcorr 
    if timePoints(n)>trialEnds(trialNum(n))
       trialNum(n) = 0; 
    end
    end
end
