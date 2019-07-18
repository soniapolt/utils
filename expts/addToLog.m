function thisSession = addToLog(logName)
% function addToLog(demo,logName)
% this function will check for the existance of a log file and either load
% or create it; if it exists, this subject is appended to the log
%  input: demo should contain fields: name (initials), age, gender, and
%  time
% logName = 'testLog.mat';

initials = input('Subject Initials: ','s');
subjNum = input('Subject Number: ');
age = input('Subject Age: ');
gender = input('Subject Gender (M/F/O): ','s');

if exist(logName,'file') load(logName);
    ind = length(session)+1;
    session(ind).name = initials;
    session(ind).num = subjNum;
    session(ind).age = age;
    session(ind).gender = gender;
    session(ind).date = datestr(now);
else 
    session = struct('name',initials,'num',subjNum,'age',age,'gender',gender,'date',datestr(now,0));
end

save(logName,'session');
fprintf('Added subject %s (session #%d) to log: %s.\n',initials,length(session),logName);
thisSession = session(end);

%end

