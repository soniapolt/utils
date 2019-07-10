function edfRead(fPath,ascDir)
% adapted from AR's eyetrackQA.m - simpler edf reading

% parse path to file
[edfDir,fName,~] = fileparts(fPath);
if ~exist('ascDir','var') ascDir = pwd; end
checkDir(ascDir);

% the edf2asc binary script used in this function only runs on Macs
if ~ismac
    error('This function can only be run on a Mac.');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% convert edf to asc files
% there is a unix script called edf2asc that will be called - it lives in sputils
unix([spUtils '/eyetrack/edf2asc '  edfDir '/' fName '.edf -p ' ascDir]);
%end