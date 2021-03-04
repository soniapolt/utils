function [filePath,fileDir,fileName] = nsd_pRFfile(whichModel,R2cutoff,hems)
% file naming convention for pre-filtered pRFs, nsd edition
if ~iscell(hems) hems = {hems}; end

fileDir = [raid 'NSDprf/output/prfsets/'];
checkDir(fileDir);

if isnumeric(R2cutoff)
    cutoff = ['r2-' num2str(R2cutoff)]; % old syntax
else cutoff = R2cutoff; end % can be perc-50 or w/e
    
fileName = [whichModel '_' hemText(hems) '_' cutoff  '.mat'];

filePath = fullfile(fileDir,fileName);
end

