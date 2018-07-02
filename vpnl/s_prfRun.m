
%% Run PRF models
% assumes that the datatypes with the averaged tseries are already created
% and xformed
%
% rl 08/2014
% Adapted by JG 03/2016
clear all; close all; clc;
dataDir = '/sni-storage/kalanit/biac2/kgs/projects/Longitudinal/FMRI/Retinotopy/data/';
cd(dataDir);
error={};
%% modify  --------------------------------------------------------------------------

% session list. see bookKeeping
% list_path = {'ACM07_09142014' 'AD25_04212015' 'AG10_07302014'...
%     'AI24_08192015' 'AlS07_10172015' 'AOK07_09212014'...
%     'AW05_03212015' 'AW05_08242015' 'AyS10_10172015'...
%     'BJ22_09242015' 'BM24_08292015' 'CB24_11022015'...
%     'CGSA11_09212014' 'CLC06_03302015' 'CR24_02132016'...
%     'CS11_11162015' 'DAPA10_09212014' 'EA23_09062015'...
%     'GB23_10232015' 'GEJA09_07192014' 'JBD11_04232015'...
%     'JM25_10262015' 'JP23_04042015' 'KG22_02192016'...
%     'KM25_03252015' 'KW10_03152015' 'LB23_12142014'...
%     'LG17_07182015' 'LL11_08012015' 'MB26_01272016'...
%     'MBA24_04302015' 'MC26_09062015' 'MDT09_03012015'...
%     'MEC05_08312014' 'MEC05_09282014' 'MFC11_09072014'...
%     'MMC27_10022015' 'MW23_04122015' 'NC24_02132016'...
%     'NT22_10152015' 'NW10_07192015' 'OS12_08082014'...
%     'RHSA06_07192014' 'RJ09_08262015' 'RJM10_06282015'...
%     'SDO06_12132015' 'SDS07_07122014'...
%     'SERA10_07192014' 'STM10_05252014' 'WAH26_02222016'...
%     'ZCM05_09142014' 'JH22_01202016' 'EDO07_12132015'...
%     'AWMS24_03212016' 'MJW22_03142016'};

% NOMO subjects
% list_path = {'AG10_07302014' 'AW05_08242015' 'AyS10_10172015' ...
%              'CS11_11162015' 'EDO07_12132015' 'GEJA09_07192014'...
%              'JBD11_04232015' 'KW10_03152015' 'MEC05_09282014'...
%              'RHSA06_07192014' 'RJM10_06282015' 'SERA10_07192014'...
%              'JM25_10262015' 'MMC27_10022015' 'NT22_10152015'};

% Adults
% list_path = {'LG17_07182015' 'BJ22_03122016' 'KG22_02192016' ...
%                'NT22_10152015' 'JH22_01202016' 'MJW22_03142016'...
%                'EA23_09062015' 'GB23_10232015' 'JP23_04042015'...
%                'LB23_12142014' 'MW23_04122015' 'ML23_03092016'...
%                'SL23_03082016' 'AI24_08192015' 'JG24_08212014'...
%                'AWMS24_03212016' 'CR24_02132016' 'BM24_08292015'...
%                'CB24_11022015' 'MBA24_04302015' 'AD25_04212015'...
%                'JM25_10262015' 'KM25_03252015' 'MB26_01272016'...
%                'MC26_09062015' 'WAH26_02222016' 'MMC27_10022015'};
    
list_path = {'JG27_02182017_amblyopia'};

% list of knk scan number, corresponding to session list
list_numKnk = 1;

% dataTYPE name. Can run for mutiple datatypes
list_rmName = {'Averages'};

% roi name. assumes in shared directory
% if we want to run on the whole brain, assign this the empty string ''
% assign this to be a string in a cell otherwise {'LV1_rl'}
list_rois = '';

% prf model. Specify in a cell. Options:
% {'one oval gaussian' | 'onegaussian' | 'css'}
% Note: if we want to specify multiple models, change the naming
% convention. See outFileName
% prfModel = {'css'};
prfModel = {'css'};

% search type.
% 1 = grid search only ("coarse"),
% 2 = minimization search only ("fine"),
% 3 = grid followed by minimization search [default]
wSearch = 3;

% radius of circle retinotopy in visual angle degrees
p.stimSize= 7;

%% define things common to all datatypes

% name of params file
p.paramsFile_Knk            = 'Stimuli/8bars_params.mat';  % 8bars parameter files
% image file
p.imFile_Knk                = 'Stimuli/8barsimages.mat';   % 8bars movie file

% params common to all dts
params.stimSize       = p.stimSize;
params.fliprotate       = [0 0 0];
params.stimType       = 'StimFromScan';
params.stimWidth      = 90;
params.stimStart        = 0;
params.stimDir          = 0;
params.nCycles          = 1;
params.nStimOnOff     = 0;
params.nUniqueRep    = 1;
params.nDCT             = 1;
params.hrfType          = 'two gammas (SPM style)';
params.hrfParams       = {[1.6800 3 2.0500] [5.4000 5.2000 10.8000 7.3500 0.3500]};
params.imfilter         = 'binary';
params.jitterFile       = 'Stimuli/none';


%% loop over all subjects

for ii = 1:length(list_path)
    try
        % directory with ret vista session. move here
        cd(fullfile(dataDir, list_path{ii}));
        
        % open the session
        vw = initHiddenGray;
        
        % need some global variables later
        load mrSESSION;
        
        % ret parameters based on the subject
        % scan number with checkers and knk, for clip frame information
        p.scanNum_Knk = list_numKnk;
        
        %% loop over the datatypes
        for kk = 1:length(list_rmName)
            
            % set current dataTYPE
            rmName = list_rmName{kk};
            vw = viewSet(vw, 'curdt', rmName);
            
            % get the dataType struct
            dtstruct = viewGet(vw, 'dtstruct');
            
            % get the data type number for later
            dataNum = viewGet(vw, 'curdt');
            
            % Set parameter and image files
            params.paramsFile   = p.paramsFile_Knk;
            params.imFile           = p.imFile_Knk;
            p.scanNum               = p.scanNum_Knk;
            
            
            %% getting parameter values for prf model fit ----------------------
            params.nFrames              = viewGet(vw, 'nFrames');
            params.framePeriod          = viewGet(vw, 'framePeriod');
            tem.totalFrames             = mrSESSION.functionals(p.scanNum).totalFrames;
            params.prescanDuration      = (tem.totalFrames - params.nFrames)*params.framePeriod;
            
            % store it
            dataTYPES(dataNum).retinotopyModelParams = params;
            
            % save it
            saveSession;
            
            %% Put the rm params into the view structure
            
            vw = rmLoadParameters(vw);
            % the function rmLoadParameters used to call both rmDefineParameters
            % and rmMakeStimulus. If we do it here so that we can give it arguments
            % outside of the default (eg previously, sigma major and minor would be
            % identical despite having prfModel = {'one oval gaussian'} when
            % specifying it as an argument in vw = rmMain(vw, ...)
            
            % store params in view struct
            vw  = viewSet(vw,'rmParams',params);
            
            % check it
            % rmStimulusMatrix(viewGet(vw, 'rmparams'), [],[],2,false);
            
            %% RUN THE PRF!
            
            % name the ret model - whole brain
            name = prfModel{1}; name(isspace(name))=[];
            outFileName = ['retModel-' name];
            
            % no need to load rois, just run it!
            vw = rmMain(vw, [], wSearch, 'model', prfModel, 'matFileName', outFileName);
        end
        
    catch
        % If someone crashed, store their name and we will print the
        % problem subjects to you later
       error{end+1} = list_path{ii};
       continue
        
    end
    
end
 %% Print problem subjects to screen
 display(error)