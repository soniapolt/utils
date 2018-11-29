function [behav,perfPlot] = invPRF3_getBehavior(session,numRuns,exptDir,reload)


behavDir = [exptDir '/' session '/Stimuli/output/'];
saveDir = [exptDir '/behav']; checkDir(saveDir);

if ~exist([saveDir '/' session '_behav.mat']) || exist('reload','var')
    
    load([behavDir 'invPRF3_1.mat'],'condition');
    behav = struct('perf',[],'targs',[],'pos',{condition.pos},'condNum',{condition.num});
    
    for n = 1:numRuns
        load([behavDir 'invPRF3_' num2str(n) '.mat'],'scan','trial','flip');
        
        targs = vertcat(trial.targ); targs = find(targs(:,scan.task));
        hits = flip.trials(scan.correctTarget);
        misses = setdiff(targs,hits);
        
        for h = [trial(hits).cond];
            behav(h).targs = [behav(h).targs 1]; end
        
        for m = [trial(misses).cond]
            behav(m).targs = [behav(m).targs 0]; end
    end
    
    for c = 1:length(behav)
        behav(c).perf = mean(behav(c).targs);
        behav(c).nTargs = length(behav(c).targs);
    end
    
    % messy but meh
    % this was a post-hack to make this function compatible with newer
    % plotCode
    c = [behav.perf];
    perfPlot(1).vect = c(1:25);
    perfPlot(1).mat = reshape(c(1:25),5,5)';
    perfPlot(1).name = 'Inverted';
    perfPlot(2).vect = c(26:50);
    perfPlot(2).mat = reshape(c(26:50),5,5)';
    perfPlot(2).name = 'Misaligned';
    perfPlot(3).vect = c(51:75);
    perfPlot(3).mat = reshape(c(51:75),5,5)';
    perfPlot(3).name = 'Upright';
    
    save([saveDir '/' session '_behav.mat'],'behav','perfPlot');
else
    load([saveDir '/' session '_behav.mat'],'behav','perfs');
end
