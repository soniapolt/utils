function [session, numRuns] = vpnlSessions(expt,subject,sessNum,task)
% takes subject initials & session number and returns the session path
% made to be flexible for fixPRF scanning & beyond

if ~exist('sessNum','var') sessNum = 1; end

switch expt
    case 'nhp'
        s = {'george'};
        subj(1).sess = {'george'};
        subj(1).runNums = [1];
        
    case 'fixPRF'
        
        s = {'AS' 'EM' 'JG' 'SP' 'TH' 'AR' 'MN' 'DF' 'MG' 'MH' 'JP' 'JW' 'JC' 'JJ' 'MZ'};
        
        subj(1).sess = {'AS180807'};
        subj(1).runNums = [9];
        
        subj(2).sess = {'EM181008' 'EM180809'};
        subj(2).runNums = [10 10];
        
        subj(3).sess = {'JG181126' 'JG180813'};
        subj(3).runNums = [10 12];
        
        subj(4).sess = {'SP181219' 'SP180814'};
        subj(4).runNums = [10 10];
        
        subj(5).sess = {'TH180925'};
        subj(5).runNums = [8];
        
        subj(6).sess = {'AR180927'};
        subj(6).runNums = [10];
        
        subj(7).sess = {'MN181001'};
        subj(7).runNums = [8];
        
        subj(8).sess = {'DF181030'};
        subj(8).runNums = [10];
        
        subj(9).sess = {'MG181119'};
        subj(9).runNums = [10];
        
        subj(10).sess = {'MH190927'};
        subj(10).runNums = [10];
        
        subj(11).sess = {'JP190906'};
        subj(11).runNums = [10];
        
        subj(12).sess = {'JW191007'};
        subj(12).runNums = [10];
        
        subj(13).sess = {'JC191004'};
        subj(13).runNums = [8];
        
        subj(14).sess = {'JJ191004'};
        subj(14).runNums = [10];
        
        subj(15).sess = {'MZ191011'};
        subj(15).runNums = [10];
        
    case 'compPRF'
        s = {'SP' 'DF' 'EM' 'TH' 'JG' 'MG'};
        
        subj(1).sess = {'SP181018'};
        subj(1).runNums = [7];
        
        subj(2).sess = {'DF181113'};
        subj(2).runNums = [8];
        
        subj(3).sess = {'EM181113'};
        subj(3).runNums = [8];
        
        subj(4).sess = {'TH181113'};
        subj(4).runNums = [8];
        
        subj(5).sess = {'JG181114'};
        subj(5).runNums = [8];
        
        subj(6).sess = {'MG181121'};
        subj(6).runNums = [8];
    case 'invPRF3'
        
        s = {'MG' 'JG' 'SP' 'DF'};
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
        
        subj(4).task(1).sess = {'DF180709'};
        subj(4).task(1).runNums = [8];
        subj(4).task(2).sess = {'DF180717'};
        subj(4).task(2).runNums = [8];
end

if ~exist('task','var') || isempty(task)
    session = subj(ismember(s, subject)).sess{sessNum};
    numRuns = subj(ismember(s, subject)).runNums(sessNum);
else
    session = subj(ismember(s, subject)).task(ismember(t, task)).sess{sessNum};
    numRuns = subj(ismember(s, subject)).task(ismember(t, task)).runNums(sessNum);
end

end

