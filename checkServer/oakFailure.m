function oakFailure(logDir,user,noNote)
% if you've just been disconnected from oak, run this function to make a
% note of the failure
%
% logDir = where you'll keep a local .mat file that will be pushed to the
% oakLog.txt once the server is back online
%
% user = string of user initials (e.g. 'SP'). if empty, function will
% prompt you
%
% noNote = flag to skip the 'add note' prompt
%

if ~exist('user','var')
    user = input('Your Initials? ','s');
end

if ~exist('logDir','var')
    logDir = pwd;
end

% initialize or open log text
logText = [];
logText = [logText sprintf('\n****\nServer connection failure on %s, reported by %s \n\n', datestr(now,0),user)];

% prompt user to enter a note with this report
if ~exist('noNote','var') || noNote==0 % enables us to skip the note prompt (like if you're running this via cron)
    addNote = input('Add note? 1 = Yes, 0 = No \n');
    if addNote
        logText = [logText sprintf('Note: %s \n\n',input('Type note: ','s'))];
    end
end

save(fullfile(logDir,'localFailLog.mat'),'logText');

