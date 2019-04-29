function checkOak(user,noNote,newLog)
% performs and times some operations on the server, outputs a log file
% also allows you to optionally add a note via input prompt
%default is oakLog.txt in sonia/utils/checkServer
% 
% all inputs are optional
%
% user = string of user initials (e.g. 'SP'). if empty, function will
% prompt you
% 
% noNote = flag to skip the 'add note' prompt - useful if we're automating
% the check
% 
% newLog = would you like to initialize a new log? enter its name here,
% e.g. 'newLog1.txt'

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
fprintf(l, '\n****\nOak tests, %s. Connected via %s, run by %s \n\n', datestr(now,0),txt,user);
fprintf('\n****\nOak tests, %s. Connected via %s, run by %s.\n\n', datestr(now,0),txt,user);

% test one: load a simple .mat file
myMat = [projectsDir 'invPRF/grantPilot/SP171101/mrInit_params.mat'];
tic; load(myMat); t = toc;
fprintf(l, 'Opening .mat file: %0.5fs. \n', t);
fprintf('Opening .mat file: %0.5fs. \n', t);

% test two: open a nifti file
myNifti = [projectsDir 'invPRF/grantPilot/SP171101/PRF_R1.nii.gz'];
tic; n = niftiRead(myNifti); t = toc;
fprintf(l, 'Opening nifti: %0.5fs. \n', t);
fprintf('Opening nifti: %0.5fs. \n', t);

% test three: open a softlink
mySoftLink = [projectsDir 'invPRF/fixPRF/AR180927/3DAnatomy/'];
tf = {'No' 'Yes'};
fprintf(l,'Softlink working? %s. \n', tf{isdir(mySoftLink)+1});
fprintf('Softlink working? %s. \n', tf{isdir(mySoftLink)+1});

% prompt user to enter a note with this test

if ~exist('noNote','var') || noNote==0 % enables us to skip the note prompt (like if you're running this via cron)
addNote = input('Add note? 1 = Yes, 0 = No \n');
if addNote
    fprintf(l,'Note: %s \n',input('Type note: ','s'));
end
end
%end

