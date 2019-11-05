% unifyROIs - combines (for fixPRF study) ROIs across sessions in a single
% haming convention, eliminates overlap, saves information about original
% studies

% adapted from sonia's roiPrep.m to finalize ROIs for an experiment. it will
% A) rename ROIs from different sessions/experiments to a standard preFix,
% which avoids overwriting ROIs that you share with others. it does this by
% looking for a softlink in each experimental session folder called
% 'faceLoc' or 'Retinotopy'
% B) exclude your EVC ROIs or any other set
% C) exclude overlapping voxels within this set in a prescribed order
% D) save a summary struct of info for each subject, number of vox in each ROI, which loc, and number of loc runs

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fill in this info:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all; close all;

expt = 'invPRF/fixPRF';%/invPRF/compPRF';%
exptDir = fullfile(raid,expt);

subjs = prfSubjs;

%%%% which ROIs
hems = {'rh' 'lh'};
ROIs = standardROIs('face+');
colors = {'y' 'm' 'r' 'w' 'c'};

%%%% exclusion paramenters
exclude = standardROIs('EVC');
removeOverlap = -1; % remove overlap between the faceROIs themselves (separate from exclude EVC); 0 = no, -1 = reverse standardROIs order (recommended), 1 = standardROIs order

%%%% naming convention of output; input is given by vpnlROIs (for now)
newPre = 'fixPRF_f_';     % preFix to add to the ROI name - usually expt_f/a_.

%%%%% comment field information - session & anat will be auto-filled
comment.name = 'Sonia Poltoratski';
comment.note = 'Oct 2019';
outStr = []; % aggregate output information, display at end (since mrV output will disrupt readability)

%%%%% output info
outputMat = [exptDir '/faceROIinfo.mat'];
outputTxt = [exptDir '/faceROIinfo.txt'];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% start processing ROIs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% housekeeping
if removeOverlap == -1 ROIs = fliplr(ROIs); colors = fliplr(colors); end % clean in reverse-heirarchy order

for s = 1:length(subjs)
    
% initialize info/comment formatting for this subject    
session = vpnlSessions('fixPRF',subjs{s});
cd(fullfile(exptDir,session,'faceLoc/'));
info{s}.missing = []; % track which ROIs we don't locate
info{s}.numVox = zeros(length(hems),length(ROIs));
outStr = [outStr sprintf('\n***%s***\n',subjs{s})];
comment.sess = pwd;

% initialize hidden gray
vw = initHiddenGray('Averages');

for h = 1:length(hems) 
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % create a single exclusion ROI for this hemisphere
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    for n = 1:length(exclude) vw = loadROI(vw,vpnlROI([hems{h} '_' exclude{n}],subjs{s}),[],[],[],0); end
    [vw, roi, ~] = combineROIs(vw,1:length(vw.ROIs), 'union', 'exclude','k');
    vw = deleteROI(vw,1:length(vw.ROIs)-1); % exclude is vw.ROIs(1) for the rest of this processing
    
    for r = 1:length(ROIs) 
        
        % input and output ROI names for this hemisphere
        inROI = vpnlROI([hems{h},'_' ROIs{r}],subjs{s});
        outROI = strcat(newPre,hems{h},'_',ROIs{r});
        info{s}.outROIs{h,r} = outROI;
        
        % check if they exist in the current loc shared path
        if ~exist(fullfile('3DAnatomy','ROIs',[inROI '.mat']))
            fprintf('Missing %s...\n',inROI);
            info{s}.missing = [info{s}.missing inROI];
            outStr = [outStr sprintf('Missing %s %s...\n',subjs{s},inROI)];
        else
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % scrape info about localizer & add comments
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            % how many runs?
            if exist([pwd '/Stimuli']) pars = dir([pwd '/Stimuli/parfiles/*par']); else pars = dir([pwd '/stim/parfiles/*par']); end
            comment.numRuns = length(pars);
            
            % which localizer was this?
            lookFor = {'fLoc' 'CategoryChannels' 'kidLoc'};
            for n = 1:length(lookFor)
                if containsTxt(pars(1).name,lookFor{n}) comment.loc = lookFor{n}; end
            end
            
            % aggregate info into ROI comment field in mrVista, and our
            % info struct
            comment.txt = sprintf('Session: %s\nExperiment: %s\nNum runs: %d\nOriginal name: %s\nAuto-excluding: %s\nDrawn by: %s\nNote: %s\n',...
                comment.sess,comment.loc,comment.numRuns,inROI,strTogether(exclude),comment.name,comment.note);
            if h == 1 && r == 1
                info{s}.subj = subjs{s};
                info{s}.comment = comment;
                info{s}.loc = comment.loc;
                info{s}.numRuns = comment.numRuns;
            end
            
            % load shared/input-ROI
            vw = loadROI(vw,inROI,[],[],[],0);
            
            % save ROI with new name, comment field (overwrites existing)
            vw.ROIs(end).name = outROI;
            vw.ROIs(end).color = colors{r};
            vw.ROIs(end).comment = comment.txt;
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % exclude EVC (or other set of regions)
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            % exclude our 'exclusion' ROI
            vw = combineROIs(vw, {vw.ROIs(end).name 'exclude'}, 'AnotB', outROI, colors{r}, [comment.txt]);
            
            % now save this cleaned and renamed ROI in shared
            [vw, ~, ~] = saveROI(vw,length(vw.ROIs), 0, 1);    % 1 = forceSave
            info{s}.numVox(h,r)= size(vw.ROIs(end).coords,2);
            outStr = sprintf('%sExcluded %s and saved %s as %s...\n',outStr,strTogether(exclude),inROI,outROI);
            vw = deleteROI(vw,2:length(vw.ROIs)); % deletes everything except for 'exclude' ROI
        end
    end
    
    vw = deleteROI(vw,1:length(vw.ROIs));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % cleaning loop to remove overlap in our face (or other) regions,
    % heirarchically
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    if abs(removeOverlap)
    vw = loadROI(vw,strcat(newPre,hems{h},'_',ROIs{1}),[],[],[],0);  
    
    for r = 2:length(ROIs)
        vw = loadROI(vw,strcat(newPre,hems{h},'_',ROIs{r}),[],[],[],0);
        
        % current ROI
        roiCurr = vw.ROIs(r).name;
        
        % prev ROI
        roiExcl = vw.ROIs(r-1).name;
        
        % now clean and rename, adding our comment text
        vw = combineROIs(vw, {roiCurr roiExcl}, 'AnotB', strcat(newPre,hems{h},'_',ROIs{r}), colors{r}, [vw.ROIs(end).comments 'Overlap removed via unifyROI.m']);
        
        % now we want to delete the old uncleaned ROI from the view
        vw = deleteROI(vw, find(strcmp(roiCurr,{vw.ROIs.name}),1)); % now sensitive to the fact that ROI name does not necessarily differ between clean & unclean
        
        % now save this cleaned and renamed ROI both locally and in shared
        [vw, ~, ~] = saveROI(vw, r, 0, 1); % save to shared
        outStr = sprintf('%sRemoved voxels in %s from %s, re-saved as %s...\n',outStr,roiExcl,roiCurr,strcat(newPre,hems{h},'_',ROIs{r}));
    end
    end
end

mrvCleanWorkspace;
end

fprintf(['\n\n\n' outStr]);
save(outputMat,'info');

% text pRF info
ROIs = reshape(info{1}.outROIs',1,numel(info{1}.outROIs));

fid = fopen(outputTxt,'w');
fprintf(fid,[sprintf('subj\tloc\tnumRuns') sprintf('\t%s',ROIs{:})]); % header

data  = [];
for s = 1:length(info)
    data = sprintf('%s\n%s\t%s\t%d',data,info{s}.subj,info{s}.loc,info{s}.numRuns);
    voxNum = reshape(info{s}.numVox',1,numel(info{1}.outROIs));
    data=sprintf('%s%s',data,sprintf('\t%d',voxNum(:)));
end

fprintf(fid,data);
cd(dirOf(outputTxt));

