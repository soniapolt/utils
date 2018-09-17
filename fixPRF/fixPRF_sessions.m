function [session, numRuns] = fixPRF_sessions(subject,sessNum)
% takes subject initials & 'fix' or 'face' task and the session number
% (1,2...) to pull up the dated session name for invPRF3 scans

s = {'AS' 'EM' 'JG' 'SP'};

subj(1).sess = {'AS180807'};
subj(1).runNums = [9];

subj(2).sess = {'EM180809'};
subj(2).runNums = [10];

subj(3).sess = {'JG180813'};
subj(3).runNums = [12];

subj(4).sess = {'SP180814'};
subj(4).runNums = [10];

session = subj(ismember(s, subject)).sess{sessNum};
numRuns = subj(ismember(s, subject)).runNums(sessNum);
end

