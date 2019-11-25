function [fileName] = pRFfile(exptDir,expt,R2cutoff,whichStim,whichModel,hems,fitSuffix,task)
% file naming convention for pre-filtered pRFs
if ~exist('task','var') task = '';end
if ~exist('fitSuffix','var') fitSuffix = ''; elseif ~isempty(fitSuffix) fitSuffix = ['_' fitSuffix]; end

fileDir = fullfile(exptDir,expt,'prfSets');
checkDir(fileDir);

if isnumeric(R2cutoff)
    cutoff = ['r2-' num2str(R2cutoff)]; % old syntax
else cutoff = R2cutoff; end
    
if ~strcmp(hems,'')
fileName = fullfile(fileDir,[expt task '_' whichModel '_' whichStim '_' hemText(hems) '_' cutoff fitSuffix '.mat']);
else
fileName = fullfile(fileDir,[expt task '_' whichModel '_' whichStim '_' cutoff fitSuffix '.mat']);    
end
end

