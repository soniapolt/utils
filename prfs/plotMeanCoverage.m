function h = plotMeanCoverage(subj,whichM,roiNum,condNum,color,plotCirc,plotIndivs)
% subj is your pRFset structure - this will plot mean prf size at the
% center of mass, and can additionally plot a circle of some size for comparison
% (e.g. 3.2dva, the size of our faces), with markings for stError across subjects

set(gca,'YDir','reverse');
ppd = subj(1).roi(1).fits(1).ppd; res = subj(1).roi(1).fits(1).res;

% get relevant means/medians - X,Y,size
    subjM =[];
    for s = 1:length(subj)
        vox = subj(s).roi(roiNum).fits(condNum).vox;
        eval(['mPars = ' whichM '(reshape([vox.params],length(vox(1).params),length(vox)),2);']);
        subjM(s,1) = mPars(2); subjM(s,2)=mPars(1);
        eval(['subjM(s,3) = ' whichM '([vox.size]);']);
    end


meanVox = mean(subjM); steVox = std(subjM)/sqrt(size(subjM,1));

% plot either individual means, and/or error bars
if plotIndivs
    for s = 1:size(subjM,1)
        hold on; plotCircle(subjM(s,1),subjM(s,2),subjM(s,3)*ppd,color,.4,'edge'); hold on; % center
        plot(subjM(s,1),subjM(s,2),'.','Color',color*.4); hold on;
    end
end
    plotCircle(meanVox(1),meanVox(2),(meanVox(3)+steVox(3))*ppd,color,.5,'fill'); hold on; 
    plotCircle(meanVox(1),meanVox(2),(meanVox(3)-steVox(3))*ppd,[1 1 1],.9,'fill'); hold on;
    %set(h(2),'Linewidth',1,'LineStyle','-.-'); hold on;
    
    % plot mean/median pRF
    h(1) = plotCircle(meanVox(1),meanVox(2),meanVox(3)*ppd,color,1,'edge'); 
    plot(meanVox(1),meanVox(2),'.','Color',color); 
    set(h(1),'Linewidth',2); hold on;
    
    %concentric circles at each dva
    for n = floor([0:1:(res/ppd)/2])
        a = plotCircle(res/2,res/2,n*ppd,[0 0 0],.75,'edge'); % center
        set(a,'Linewidth',1); hold on;
    end
    
    set(gca,'visible','off'); hline(res/2,'k--'); vline(res/2,'k--');
    axis([.5 res+.5 .5 res+.5]); axis square;
    
%     if ~isempty(leg)
%         g=legend([h],leg); set(g,'box','off','location','best');end
    
   text(res*.6,res*.8,sprintf('Center of mass (X,Y) = [%g, %g]\n',round(meanVox(1)),round(meanVox(2))));

    
    if exist('plotCirc','var') && plotCirc>0
        hold on; a = plotCircle(res/2,res/2,plotCirc/2*ppd,[1 .5 .5],1,'edge'); % center
        set(a,'Linewidth',1); hold on;
    end
%end

