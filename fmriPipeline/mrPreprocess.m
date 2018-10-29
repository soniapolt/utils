%function err = mrPreprocess(expt,session, clip, stc_flag)
% Automated analysis of fMRI data from fLoc funcional localizer experiment 
% using vistasoft functions (https://github.com/vistalab/vistasoft). 
% 
% INPUTS
% 1) session: name of session in ~/fLoc/data/ to analyze (string)
% 2) clip: number of TRs to clip from the beginning of each run (int)
% 3) stc_flag: slice time correction flag (logical; default = 0, no STC)
% 4) contrasts (optional): custom user-defined contrasts (struct)
%      contrasts(N).active  -- active condition numbers for Nth contrast
%      contrasts(N).control -- control condition numbers for Nth contrast
%
% OUTPUTS
% 1) err: 1 if analysis terminated with an error, 0 if analysis completed
% 
% By default the code generates the following voxel-wise parameters maps: 
% Beta values, model residual error, proportion of variance explained, and
% GLM contrasts (t-values). All parameter maps are saved as .mat files in 
% ~/fLoc/data/*/Inplane/GLMs/ and can be viewed in vistasoft. The code also
% writes a file named "fLocAnalysis_log.txt" that logs progress of the 
% analysis in vistasoft.
% 
% AS 7/2018
% Adapted by SP 8/2018 to do preprocessing, without loc-specific further
% analysis
clear all;
expt = 'invPRF/compPRF'; session = 'SP181018'; clip = 5; stcFlag = 0; canonXFlag = 0;
runBase  = 'run'; % or 'run';


% Check and validate inputs and path to vistasoft
baseDir = fullfile('/sni-storage','kalanit','biac2','kgs','projects');

if isempty(which('mrVista'))
    vista_path = 'https://github.com/vistalab/vistasoft';
    error(['Add vistasoft to your matlab path: ' vista_path]);
end


% standardize and validate session argument
exptDir = fullfile(baseDir,expt);

dd = dir(exptDir); allSessions = {dd([dd.isdir]).name};
if length(allSessions) < 3
    error(['No valid session data directories found in ' exptDir]);
else
    allSessions = allSessions(3:end);
end
if sum(strcmp(session, allSessions)) ~= 1
    error(['Session ' session ' not found in ' exptDir]);
end

% look for parfiles corresponding to each run of fMRI data
sessionDir = fullfile(exptDir, session);
cd(sessionDir); fns = dir(sessionDir); fns = {fns.name};
lid = fopen('preprocess_log.txt', 'w+');
fprintf(lid, 'Starting preprocessing analysis for session %s. \n\n', session);
fprintf('Starting preprocessing for session %s. \n\n', session);

% apply cannonical transformation to nifti files and resave
if canonXFlag transformerDir(sessionDir); end

runCount = 0;
for n = 1:length(fns)
    if containsTxt(fns{n},runBase)
        runCount=runCount+1;
        niiFiles{runCount} = fns{n};
    end
end
nii = niftiRead(niiFiles{1}); nSlices = size(nii.data, 3);  tr = nii.pixdim(4); clear nii;
        
% checks for par files
niiFiles = natsort(niiFiles);
niiFiles = cellfun(@(X) fullfile(sessionDir, X), niiFiles, 'uni', false);

pars = dir(fullfile(sessionDir,'Stimuli','parfiles','*.par')); pars = natsort({pars.name});
if length(pars) < runCount
        fprintf(lid, 'Error -- Missing some stimulus parameter (.par) files \nContinued analysis.', session);
        fprintf('Error -- Missing some stimulus parameter (.par) files \nContinued analysis.', session);
end

pars= cellfun(@(X) fullfile(sessionDir,'Stimuli','parfiles', X), pars, 'uni', false);

if length(clip) == 1
    clip = repmat(clip, 1, runCount);
elseif length(clip) ~= length(session)
    fprintf(lid, 'Error -- Length of clip argument is inconsistent with number of runs. \nExited analysis.');
    fprintf('Error -- Length of clip argument is inconsistent with number of runs. \nExited analysis.');
    fclose(lid); return;
end
keepFrames = [clip(:) repmat(-1, length(clip), 1)];
% to fix TH's session
% keepFrames(1,2) = 120; keepFrames(2,2) = 120;

% Initialize session and preprocess fMRI data

% setup analysis parameters for GLM
params = mrInitDefaultParams;
params.doAnalParams = 1;
params.doSkipFrames = 1;
params.doPreprocessing = 1;
params.functionals = niiFiles;     % paths to runs of fMRI data
params.subject = session;          % name of session directory
params.keepFrames = keepFrames;   % TRs to model (after clipping)
params.parfile = pars;         % paths to parfiles
params.scanGroups = {1:runCount};      % group all runs of localizer
params.motionComp = 0;             % disable motion correction for now
params.motionCompRefFrame = 8;     % reference TR for motion correction
params.motionCompSmoothFrames = 3; % smoothing window for motion correction

% look for T1 volume and leave blank if none exists
if exist(fullfile(sessionDir, '3DAnatomy', 't1.nii.gz'), 'file') == 2
    params.vAnatomy = fullfile(sessionDir, '3DAnatomy', 't1.nii.gz');
end

% look for inplane volume
dd = dir('*inplane*'); if isempty(dd) dd = dir('*Inplane*'); end
inplane = dd.name;
if isempty(inplane)
    fprintf(lid, 'Warning -- Inplane scan not found. Continued analysis. \n');
    fprintf('Warning -- Inplane scan not found. Continued analysis. \n');
else
    params.inplane = fullfile(sessionDir, inplane);
end

% inititalize vistasoft session and open hidden inplane view
fprintf(lid, 'Initializing vistasoft session directory in: \n%s \n\n', sessionDir);
fprintf('Initializing vistasoft session directory in: \n%s \n\n', sessionDir);
if ~exist(fullfile(sessionDir, 'Inplane'), 'dir')
    mrInit(params);
end
hi = initHiddenInplane('Original', 1);

% do slice timing correction assuming interleaved slice acquisition
if stcFlag
    fprintf(lid, 'Starting slice timing correction... \n');
    fprintf('Starting slice timing correction... \n');
    if ~exist(fullfile(sessionDir, 'Inplane', 'Timed'), 'dir') ~= 7
        load(fullfile(sessionDir, 'mrSESSION'));
        for rr = 1:runCount
            mrSESSION.functionals(rr).sliceOrder = [1:2:nSlices 2:2:nSlices];
        end
        saveSession; hi = initHiddenInplane('Original', 1);
        hi = AdjustSliceTiming(hi, 0, 'Timed');
        saveSession; close all;
    end
    fprintf(lid, 'Slice timing correction complete. \n\n');
    fprintf('Slice timing correction complete. \n\n');
    hi = initHiddenInplane('Timed', 1);
end

% do within-scan motion compensation and check for motion > 2 voxels
fprintf(lid, 'Starting within-scan motion compensation... \n');
fprintf('Starting within-scan motion compensation... \n');
setpref('VISTA', 'verbose', false); % suppress wait bar
if exist(fullfile(sessionDir, 'Images', 'Within_Scan_Motion_Est.fig'), 'file') ~= 2
    hi = motionCompSelScan(hi, 'MotionComp', 1:runCount, ...
        params.motionCompRefFrame, params.motionCompSmoothFrames);
    saveSession; % close all;
end

fprintf(lid, 'Within-scan motion compensation complete. \n\n');
fprintf('Within-scan motion compensation complete. \n\n');

% do between-scan motion compensation and check for motion > 2 voxels
fprintf(lid, 'Starting between-scan motion compensation... \n');
fprintf('Starting between-scan motion compensation... \n');
if exist(fullfile(sessionDir, 'Between_Scan_Motion.txt'), 'file') ~= 2
    hi = initHiddenInplane('MotionComp', 1); baseScan = 1; targetScans = 1:runCount;
    [hi, M] = betweenScanMotComp(hi, 'MotionComp_RefScan1', baseScan, targetScans);
    fname = fullfile('Inplane', 'MotionComp_RefScan1', 'ScanMotionCompParams');
    save(fname, 'M', 'baseScan', 'targetScans');
    hi = selectDataType(hi, 'MotionComp_RefScan1');
    saveSession; close all;
end

fprintf(lid, 'Between-scan motion compensation complete. \n\n');
fprintf('Between-scan motion compensation complete. \n\n');

% % remove spikes from each run of data with median filter
% fdir = fullfile(sessionDir, 'Inplane', 'MotionComp_RefScan1', 'TSeries');
% fprintf(lid, 'Removing spikes from voxel time series. \n\n');
% fprintf('Removing spikes from voxel time series. \n\n');
% for rr = 1:runCount
%     fstem = ['tSeriesScan' num2str(rr)];
%     if ~exist(fullfile(fdir, [fstem '_raw.nii.gz']), 'file') == 2
%         copyfile(fullfile(fdir, [fstem '.nii.gz']), fullfile(fdir, [fstem '_raw.nii.gz']));
%         nii = MRIread(fullfile(fdir, [fstem '.nii.gz']));
%         [x, y, z, t] = size(nii.vol); swin = ceil(3 / (nii.tr / 1000));
%         tcs = medfilt1(reshape(permute(nii.vol, [4 1 2 3]), t, []), swin, 'truncate');
%         nii.vol = permute(reshape(tcs, t, x, y, z), [2 3 4 1]);
%         MRIwrite(nii, fullfile(fdir, [fstem '.nii.gz']));
%     end
% end

% set event-related parameters
er_params = er_defaultParams;
er_params.detrend = -1;      % linear detrending
er_params.glmHRF = 3;        % difference-of-gammas HRF
er_params.lowPassFilter = 0; % do not low-pass filter by default
er_params.eventsPerBlock = 2; % specific for facePRF experiment! 
er_params.framePeriod = tr; %TR

% group scans of preprocessed data and set event-related parameters
hi = initHiddenInplane('MotionComp_RefScan1', params.scanGroups{1}(1));
hi = er_groupScans(hi, params.scanGroups{1});

er_setParams(hi, er_params);
hi = er_assignParfilesToScans(hi, params.scanGroups{1}, pars);
saveSession; close all;

fprintf(lid, 'preProcessing for %s is complete! \n', session);
fprintf('preProcessing for %s is complete! \n', session); fclose(lid);
err = 0;

