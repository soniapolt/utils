%function err = mrPreprocess(expt,session, clip, stc_flag)
% based on fLocAnalysisOriginal.m, written by AS
% 
% Adapted by SP 8/2018 run following mrPreprocess, a more general script
% that gets us to MotionComp_RefScan1

clear all;
expt = 'sonia/localizers/fLoc';  session = 'MN181023'; 
runBase  = 'run'; % or 'run';


% Check and validate inputs and path to vistasoft
baseDir = fullfile('/share','kalanit','biac2','kgs','projects');

% standardize and validate session argument
exptDir = fullfile(baseDir,expt);

% get TR number
sessionDir = fullfile(exptDir, session); cd(sessionDir);
nii= dir('*1.nii*'); nii = niftiRead(nii.name); tr = nii.pixdim(4); clear nii;

% load session to access parameters, set in mrPreprocess.m
load('mrInit_params.mat');
runCount = length(params.functionals);
%% Analyze fMRI data and generate model parameter maps

% set event-related parameters
er_params = er_defaultParams;
er_params.detrend = -1;      % linear detrending
er_params.glmHRF = 3;        % difference-of-gammas HRF
er_params.lowPassFilter = 0; % do not low-pass filter by default

% calculate number of frames per block
[onsets, cond_nums, conds] = deal([]); cnt = 0;
for rr = 1:runCount
    fid = fopen(params.parfile{rr}, 'r');
    while ~feof(fid)
        ln = fgetl(fid); cnt = cnt + 1;
        if isempty(ln); return; end; ln(ln == sprintf('\t')) = '';
        prts = deblank(strsplit(ln, ' ')); prts(cellfun(@isempty, prts)) = [];
        onsets(cnt) = str2double(prts{1});
        cond_nums(cnt) = str2double(prts{2});
        conds{cnt} = prts{3};
    end
    fclose(fid);
end

block_dur = onsets(2) - onsets(1);
frames_per_block = block_dur / tr;

% make a list of unique condition numbers and corresponding condition names
cond_num_list = unique(cond_nums); cond_list = cell(1, length(cond_num_list));
for cc = 1:length(cond_num_list)
    cond_list{cc} = conds{find(cond_nums == cond_num_list(cc), 1)};
end

% remove baseline from list of conditions
bb = find(cond_num_list == 0); cond_num_list(bb) = []; cond_list(bb) = [];


% group scans of preprocessed data and set event-related parameters
hi = initHiddenInplane('MotionComp_RefScan1', params.scanGroups{1}(1));
hi = er_groupScans(hi, params.scanGroups{1});
er_params.eventsPerBlock = frames_per_block;
er_params.framePeriod = tr;
er_setParams(hi, er_params);
hi = er_assignParfilesToScans(hi, params.scanGroups{1}, params.parfile);
saveSession; close all;

% run GLM and compute default statistical contrasts
%fprintf(lid, 'Performing GLM analysis for %s... \n\n', session);
fprintf('Performing GLM analysis for %s... \n\n', session);
hi = initHiddenInplane('MotionComp_RefScan1', params.scanGroups{1}(1));
hi = applyGlm(hi, 'MotionComp_RefScan1', params.scanGroups{1}, er_params);
hi = initHiddenInplane('GLMs', 1);
for cc = 1:length(cond_num_list)
    active_conds = cc; control_conds = cond_num_list(cond_num_list ~= cc);
    contrast_name = [cond_list{cc} '_vs_all'];
    hi = computeContrastMap2(hi, active_conds, control_conds, ...
        contrast_name, 'mapUnits','T');
end

%fprintf(lid, 'Default GLM parameter maps saved in: \n%s/GLMs/... \n\n', session_dir);
fprintf('Default GLM parameter maps saved in: \n%s/GLMs/... \n\n', sessionDir);

% 4) contrasts (optional): custom user-defined contrasts (struct)
%      contrasts(N).active  -- active condition numbers for Nth contrast
%      contrasts(N).control -- control condition numbers for Nth contrast

% compute custom user-defined contrast maps
% if isstruct(contrasts)
%     for cc = 1:length(contrasts)
%         active_conds = strcat(cond_list{contrasts(cc).active});
%         control_conds = strcat(cond_list{contrasts(cc).control});
%         contrast_name = [active_conds '_vs_' control_conds];
%         hi = computeContrastMap2(hi, contrasts(cc).active, ...
%             contrasts(cc).control, contrast_name, 'mapUnits','T');
%     end
%     %fprintf(lid, 'Custom GLM contrast maps saved in: \n%s/GLMs/... \n\n', session_dir);
%     fprintf('Custom GLM contrast maps saved in: \n%s/GLMs/... \n\n', session_dir);
% end
%fprintf(lid, 'fLocAnalysis for %s is complete! \n', session);
% fprintf('fLocAnalysis for %s is complete! \n', session); 

