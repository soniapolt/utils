function reportFailure(localLogDir,newLog)
% if you've made a report via oakFailure.m, run this after you're back
% online to add to the log

% are you running via mounting, or in lab?
if isdir('/Volumes/projects')
    projectsDir = '/Volumes/projects/';
    txt = 'mount';
elseif isdir('/share/kalanit/')
    projectsDir = '/share/kalanit/biac2/kgs/projects/';
    txt = 'network'; end

logDir = [projectsDir 'sonia/utils/checkServer/'];

% if you pass variable newLog, the existing log file will be overwritten
% with the name that you specify
if ~exist('localLogDir','var')
   localLogDir = pwd; 
end
if ~exist('newLog','var')
    newLog = 'oakLog.txt'; end % default log name

load(fullfile(localLogDir,'localFailLog.mat'));

% initialize or open a log file
l = fopen([logDir newLog], 'a');
fprintf(l, logText);
fprintf(logText);

end

