function edfRead(fPath,ascDir)
% adapted from AR's eyetrackQA.m - simpler edf reading
% makes one asc file with all of the data (including events), and one with
% just samples (for faster handling)

%fPath = '/Users/Sonia/Desktop/invPRFDev/ETanalysisDev/edfs/JJ190709.edf';
%fPath = '/Volumes/projects/behavFIE/pRFrec/edfs/JJ190709.edf';

% parse path to file
[edfDir,fName,~] = fileparts(fPath);
if ~exist('ascDir','var') ascDir = [pwd '/']; end
checkDir(ascDir); checkDir([ascDir 'tmp']);

% the edf2asc binary script used in this function only runs on Macs
if ~ismac
    error('This function can only be run on a Mac.');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% convert edf to asc files
% there is a unix script called edf2asc that will be called - it lives in sputils
if ~strcmp(spUtils,'/Volumes/projects/sonia/utils')
    error('This function needs access to the server: /Volumes/projects/sonia/utils');
end
unix([spUtils '/eyetrack/edf2asc '  edfDir '/' fName '.edf -p ' ascDir]);
unix([spUtils '/eyetrack/edf2asc -s -miss NaN ' edfDir '/' fName '.edf -p ' ascDir 'tmp']);
% rename samples file
movefile([ascDir '/tmp/' fName '.asc'],[ascDir fName '_samples.asc'])
rmdir([ascDir '/tmp']);
%end