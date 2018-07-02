function [behav,perfs] = invPRF3_getBehavior(session,numRuns,exptDir)


behavDir = [exptDir session '/Stimuli/output/'];
saveDir = [exptDir '/behav']; checkDir(saveDir);

if ~exist([saveDir '/' session '_behav.mat'])
    
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
    c = [behav.perf];
    perfs(:,:,1) = reshape(c(1:25),5,5)';
    perfs(:,:,2) = reshape(c(26:50),5,5)';
    perfs(:,:,3) = reshape(c(51:75),5,5)';
    
    save([saveDir '/' session '_behav.mat'],'behav','perfs');
else
    load([saveDir '/' session '_behav.mat'],'behav','perfs');
end
