function [fileName] = pRFfile(exptDir,expt,minR2,whichStim,whichModel,hems,fitSuffix,task)
% file naming convention for pre-filtered pRFs
if ~exist('task','var') task = '';end
if ~exist('fitSuffix','var') fitSuffix = '';end

fileDir = fullfile(exptDir,expt,'prfSets');
checkDir(fileDir);

if ~strcmp(hems,'')
fileName = fullfile(fileDir,[expt task '_' whichModel '_' whichStim '_' hemText(hems) '_r2-' num2str(minR2) fitSuffix '.mat']);
else
fileName = fullfile(fileDir,[expt task '_' whichModel '_' whichStim '_r2-' num2str(minR2) fitSuffix '.mat']);    
end
end

