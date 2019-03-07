function [pRFdir,regDir,regFile] = lassoDirs(exptDir,expt,subj,ppd,ROI,sherlock,weight)
% navitage local/sherlock file structure for the ridgeFit procedure
if ~exist('sherlock','var') || ~sherlock
    pRFdir = fullfile(exptDir,expt,'prfSets');
    regDir = fullfile(exptDir,'lassoFits',ROI);
    regFile = [expt '_' subj '_' num2str(ppd) 'ppd_' num2str(weight) 'wt']; % doesn't have a .mat ending so we can add the stim number to it.
elseif sherlock
    pRFdir = fullfile('/scratch','users','sonia09','prfSets');
    regDir = fullfile('/scratch','users','sonia09','lassoFits',ROI);
    regFile = [expt '_' subj '_' num2str(ppd) 'ppd_' num2str(weight) 'wt']; % doesn't have a .mat ending so we can add the stim number to it.
end

