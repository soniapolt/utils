function [session, numRuns] = vpnlSessions(expt,subject,sessNum)
% takes subject initials & session number and returns the session path
% made to be flexible for fixPRF scanning & beyond

switch expt
    case 'fixPRF'
        
        s = {'AS' 'EM' 'JG' 'SP' 'TH' 'AR' 'MN'};
        
        subj(1).sess = {'AS180807'};
        subj(1).runNums = [9];
        
        subj(2).sess = {'EM181008' 'EM180809'};
        subj(2).runNums = [10 10];
        
        subj(3).sess = {'JG180813'};
        subj(3).runNums = [12];
        
        subj(4).sess = {'SP180814'};
        subj(4).runNums = [10];
        
        subj(5).sess = {'TH180925'};
        subj(5).runNums = [8];
        
        subj(6).sess = {'AR180927'};
        subj(6).runNums = [10];
        
        subj(7).sess = {'MN181001'};
        subj(7).runNums = [8];
    case 'compPRF'
        s = {'SP'};
        
        subj(1).sess = {'SP181018'};
        subj(1).runNums = [7];
        
end

session = subj(ismember(s, subject)).sess{sessNum};
numRuns = subj(ismember(s, subject)).runNums(sessNum);

end

