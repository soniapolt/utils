function addToLog(logName,initials,subjNum,age,gender,time)
% function addToLog(demo,logName)
% this function will check for the existance of a log file and either load
% or create it; if it exists, this subject is appended to the log
%  input: demo should contain fields: name (initials), age, gender, and
%  time
% logName = 'testLog.mat';

if exist(logName,'file') load(logName); 
    session(end+1).name = initials;
    session(end+1).num = subjNum;
    session(end+1).age = age;
    session(end+1).gender = gender;
    session(end+1).date = time;
else 
    session = struct('name',initials,'subjNum',subjNum,'age',age,'gender',gender,'date',date);
end

save(logName,'session');
fprintf('Added subject %s (session #%d) to log: %s.\n',initials,length(session),logName);


%end

