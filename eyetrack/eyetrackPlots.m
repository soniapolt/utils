function eyetrackPlots(exptDir,matName,exptFile)
% in this version, each trial is plotted in its own figure
%clear all; close all;
% inputs
% exptDir = '/Users/Sonia/Desktop/invPRFDev/ETanalysisDev/prfRec';
% matName = 'JJ190709';

% directories & names
figDir = [exptDir '/figures/' matName '/']; checkDir(figDir);
load([exptDir '/mat/' matName]); % eyetracking data
%load([exptDir '/data/prfRec_' matName(1:2) '_1back.mat']); %main expt data


plt.figSize = [.1 .1 .9 .9];            % normalized units to your current screen
plt.inSpace = 1;                        % binary, plot entire trace in stimulus space for each trial
plt.inTime = 1;                         % binary, plot movements over time for each trial
plt.cond = 1;                           % binary, plot movements across trials by condition
plt.dva =  1;                           % binary, convert from pixel to dva
plt.centerCrop = 10;                    % limit plotting to +/- X degrees/pixels
plt.saveFig = [1 1 1];                  % binary, whether to save each figure

plt.markPoints = params.locsDeg;        % on some plots, mark the position at which targets appeared

for n = 1:length(trial)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % plot in stimulus space
    if plt.inSpace
        niceFig(plt.figSize,18); niceGCA;
        eyeInSpace(trial(n),eyeInit,info.rate,plt.dva,plt.centerCrop,plt.markPoints);
        title([matName ' : ' trial(n).text ', ' condition(trial(n).cond).name]);
        
        if plt.saveFig(1)
            niceSave(figDir,[matName '_inSpace_trial' num2str(n)]);
            close(gcf);
        end
        
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % plot position over time
    if plt.inTime
        niceFig(plt.figSize,18); niceGCA;
        eyeInTime(trial(n),eyeInit,info.rate,plt.dva,plt.centerCrop)
        superTitle([matName ' : ' trial(n).text ', ' condition(trial(n).cond).name],18,.05);
        if plt.saveFig(2)
            niceSave(figDir,[matName '_inTime_trial' num2str(n)]);
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
            hold on; s = eyeInSpace(trial(t),eyeInit,info.rate,plt.dva,plt.centerCrop,...
                params.locsDeg(condition(n).pos,:),1);
            title([matName ': ' condition(n).name ' (HR = ' num2str(perf(n).hitRate*100) '%, FA = ' num2str(perf(n).FArate*100) '%)']);
            cond(n).samples = [cond(n).samples; s(:,2:3)]; % aggregate samples across trials
        end
        % mark centroid of fixations
        set(0,'DefaultLegendAutoUpdate','off')
        cond(n).cent = nanmean(cond(n).samples);
        hold on; plot(cond(n).cent(1),cond(n).cent(2),'*','MarkerSize',6,'Color',condColors(6));
        text(cond(n).cent(1)+.5,cond(n).cent(2)+.5,['mean position = [' num2str(cond(n).cent(1)) ',' num2str(cond(n).cent(2)) ']'],'FontSize',10);
        if plt.saveFig(3)
            niceSave(figDir,[matName '_condAvg_' condition(n).name]);
        end
    end
    
end
%end

