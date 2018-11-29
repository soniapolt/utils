function [stim,perfPlot] = compPRF_getBehavior(session,numRuns,exptDir,reload)

%session = 'SP181018'; exptDir = '/Volumes/projects/invPRF/compPRF/';numRuns = 7;

behavDir = [exptDir '/' session '/Stimuli/output/'];
saveDir = [exptDir '/behav']; checkDir(saveDir);

if ~exist([saveDir '/' session '_behav.mat']) || exist('reload','var')
    
    % structure with organization: stim(1:2).pos(1:15).perf
    c = struct('perf',[],'overallPerf',[]);
    [c(1:25).perf] = deal([]);
    stim = struct('cond',{'Small' 'Big' 'Two' 'Blank'},'pos',c);
    
    for n = 1:numRuns
        load([behavDir 'compPRF_' num2str(n) '.mat'],'perf','trial','condition');
        if ~isempty([perf.hitTr]) % if performance is 0, we assume that this run is just a scanner error, and don't record any part of it
            hitsMisses = {[trial([perf.hitTr]).cond];[trial([perf.missTr]).cond]};
            pf = [1 0];
            for m = 1:length(hitsMisses) %hits, misses
                for t = hitsMisses{m}
                    if t ==0 stimN = 4; posN = 13;
                    else stimN = condition(t).stim; posN = condition(t).pos; end % for completeness, plot blank performance at the center
                    stim(stimN).pos(posN).perf = ...
                        [stim(stimN).pos(posN).perf pf(m)];
                end
            end
        end
    end
    
    % messy but meh
    c = 1;
    for n = 1:length(stim)
        for p = 1:length(stim(n).pos)
            perfPlot(c).name = stim(n).cond;
            if ~isempty(stim(n).pos(p).perf)
                stim(n).pos(p).overallPerf = mean(stim(n).pos(p).perf);
            else stim(n).pos(p).overallPerf = NaN; end
        end
        perfPlot(c).vect = [stim(n).pos.overallPerf];
        perfPlot(c).mat = reshape(perfPlot(c).vect,5,5)';
        c = c+1;
    end
    
    save([saveDir '/' session '_behav.mat'],'stim','perfPlot');
else
    load([saveDir '/' session '_behav.mat'],'stim','perfPlot');
end
