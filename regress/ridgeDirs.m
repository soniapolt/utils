function [pRFdir,ridgeDir,ridgeFile] = ridgeDirs(exptDir,expt,subj,ppd,ROI,sherlock)
% navitage local/sherlock file structure for the ridgeFit procedure
if ~exist('sherlock','var') || ~sherlock
    pRFdir = fullfile(exptDir,expt,'prfSets');
    ridgeDir = fullfile(exptDir,'ridgeFits',ROI);
    ridgeFile = [expt '_' subj '_' num2str(ppd) 'ppd']; % doesn't have a .mat ending so we can add the stim number to it.
elseif sherlock
    pRFdir = fullfile('/scratch','users','sonia09','prfSets');
    ridgeDir = fullfile('/scratch','users','sonia09','ridgeFits',ROI);
    ridgeFile = [expt '_' subj '_' num2str(ppd) 'ppd']; % doesn't have a .mat ending so we can add the stim number to it.
end

