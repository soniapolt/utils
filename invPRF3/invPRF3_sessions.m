function [session, numRuns] = invPRF3_sessions(subject,sessNum,task)
% takes subject initials & 'fix' or 'face' task and the session number
% (1,2...) to pull up the dated session name for invPRF3 scans

s = {'MG' 'JG' 'SP'};
t = {'fix' 'face'};

subj(1).task(1).sess = {'MG180213' 'MG180301'};
subj(1).task(1).runNums = [8, 8];
subj(1).task(2).sess = {'MG180514'};
subj(1).task(2).runNums = [8];

subj(2).task(1).sess = {'JG180320' 'JG180330'};
subj(2).task(1).runNums = [8, 8];
subj(2).task(2).sess = {'JG180514'};
subj(2).task(2).runNums = [7];

subj(3).task(1).sess = {'SP180625' 'SP180301' 'SP180307'};
subj(3).task(1).runNums = [8,4,4];
subj(3).task(2).sess = {'SP180626'};
subj(3).task(2).runNums = [8];

session = subj(ismember(s, subject)).task(ismember(t, task)).sess{sessNum};
numRuns = subj(ismember(s, subject)).task(ismember(t, task)).runNums(sessNum);
end

