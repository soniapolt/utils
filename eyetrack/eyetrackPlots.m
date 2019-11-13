function eyetrackPlots(exptDir,etName,dataName,driftCorr,whichPlots)
% in this version, each trial is plotted in its own figure
%clear all; close all;
% inputs
% exptDir = '/Volumes/projects/behavFIE/prfRec';
% etName = 'TH_2back_190721';
% dataName = 'prfRec_TH_2back';
% driftCorr = 0; whichPlots = [0 1 0];

% directories & names
figDir = [dirOf(exptDir) 'analysis/figures/' etName '/']; 
load([exptDir '/mat/' etName '.mat']); % eyetracking data
load([exptDir '/data/' dataName '.mat']); %main expt data


plt.figSize = [.1 .1 .9 .9];            % normalized units to your current screen
plt.inSpace = whichPlots(1);            % binary, plot entire trace in stimulus space for each trial
plt.inTime = whichPlots(2);             % binary, plot movements over time for each trial
plt.cond = whichPlots(3);               % binary, plot movements across trials by condition
plt.dva =  1;                           % binary, convert from pixel to dva
plt.centerCrop = 10;                    % limit plotting to +/- X degrees/pixels
plt.saveFig = [1 1 1];                  % binary, whether to save each figure
plt.driftCorr = driftCorr;              % binary, whether we apply trial-wise drift correction

plt.markPoints = params.locsDeg;        % on some plots, mark the position at which targets appeared

for n = 1:length(trial)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % plot in stimulus space
    
    if plt.inSpace
        niceFig(plt.figSize,18); niceGCA;
        eyeInSpace(trial(n),eyeInit,info.rate,plt.dva,plt.driftCorr,plt.centerCrop,plt.markPoints(condition(trial(n).cond).pos,:));
        if ~plt.driftCorr corr = [0 0]; else corr = trial(n).driftCorr; end
        title([etName ' : ' trial(n).text ', ' condition(trial(n).cond).name ', Drift Corr = [' num2str(corr(1)) ',' num2str(corr(2)) ']']);
        
        if plt.saveFig(1)
            if plt.driftCorr niceSave(figDir,[etName(9:10) '_corr_inSpace_trial' num2str(n)]);
            else niceSave(figDir,[etName(9:10) '_raw_inSpace_trial' num2str(n)]); end
            close(gcf);
        end
        
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % plot position over time
    if plt.inTime
        niceFig(plt.figSize,18); niceGCA;
        eyeInTime(trial(n),eyeInit,info.rate,plt.dva,plt.centerCrop)
        superTitle([etName ' : ' trial(n).text ', ' condition(trial(n).cond).name],18,.05);
        if plt.saveFig(2)
            niceSave(figDir,[etName '_inTime_trial' num2str(n)]);
            close(gcf);
        end
    end
end

if plt.cond
    close all;
    for n = 1:length(condition)
        niceFig(plt.figSize,18); niceGCA;
        ind = find([trial.cond]==n);
        cond(n).samples = [];
        for t = ind
            hold on; s = eyeInSpace(trial(t),eyeInit,info.rate,plt.dva,plt.driftCorr,plt.centerCrop,...
                params.locsDeg(condition(n).pos,:),1);
            title([etName ': ' condition(n).name ' (percCorrect = ' num2str(perf(n).percCorrect) '%), Drift Corr = ' num2str(plt.driftCorr)]);
            cond(n).samples = [cond(n).samples; s(:,2:3)]; % aggregate samples across trials
        end
        % mark centroid of fixations
        set(0,'DefaultLegendAutoUpdate','off')
        cond(n).cent = nanmean(cond(n).samples);
        hold on; plot(cond(n).cent(1),cond(n).cent(2),'*','MarkerSize',6,'Color',condColors(6));
        text(cond(n).cent(1)+.5,cond(n).cent(2)+.5,['mean position = [' num2str(cond(n).cent(1)) ',' num2str(cond(n).cent(2)) ']'],'FontSize',10);
        if plt.saveFig(3)
            if plt.driftCorr niceSave(figDir,[etName(9:10) '_corr_condAvg_' condition(n).name]);
            else niceSave(figDir,[etName(9:10) '_raw_condAvg_' condition(n).name]); end
        end
    end
    
end
%end

