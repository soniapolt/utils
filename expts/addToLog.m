%function addToLog(initals,subjNum,age,gender,time,logName)
% function addToLog(demo,logName)
% this function will check for the existance of a log file and either load
% or create it; if it exists, this subject is appended to the log
%  input: demo should contain fields: name (initials), age, gender, and
%  time
logName = 'testLog.mat';

if exist(logName,'file') load(logName); 
    log(end+1).name = intials;
    log(end+1).num = subjNum;
    log(end+1).age = age;
    log(end+1).gender = gender;
    log(end+1).date = date;
else 
    log = struct('name',intials,'subjNum',subjNum,'age',age,'gender',gender,'date',date);
end

save(logName,log);


%end

