function oakFailure(user,noNote,newLog)
% if you've just been disconnected from oak, run this function to make a

% are you running via mounting, or in lab?
if isdir('/Volumes/projects')
    projectsDir = '/Volumes/projects/';
    txt = 'mount';
elseif isdir('/share/kalanit/')
    projectsDir = '/share/kalanit/biac2/kgs/projects/';
    txt = 'network'; end

if ~exist('user','var')
    user = input('Your Initials? ','s');
end

logDir = [projectsDir 'sonia/utils/checkServer/'];

% if you pass variable newLog, the existing log file will be overwritten
% with the name that you specify

if ~exist('newLog','var')
    newLog = 'oakLog.txt'; end % default log name

% initialize or open a log file
l = fopen([logDir newLog], 'a');
fprintf(l, '\n****\nServer connection failure on %s, reported by %s \n\n', datestr(now,0),user);
fprintf('\n****\nServer connection failure on %s, reported by %s \n\n', datestr(now,0),user);

% prompt user to enter a note with this report
if ~exist('noNote','var') || noNote==0 % enables us to skip the note prompt (like if you're running this via cron)
    addNote = input('Add note? 1 = Yes, 0 = No \n');
    if addNote
        fprintf(l,'Note: %s \n\n',input('Type note: ','s'));
    end
end

