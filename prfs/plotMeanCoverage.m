function h = plotMeanCoverage(subj,whichM,ROInum,condNum,plotCirc,legText,color)
% subj is your pRFset structure - this will plot mean prf size at the
% center of mass, and can additionally plot a circle of some size for comparison
% (e.g. 3.2dva, the size of our faces), with markings for stError across subjects

set(gca,'YDir','reverse');
ppd = subj(1).roi(1).fits(1).ppd; res = subj(1).roi(1).fits(1).res;
  if ~exist('color','var') color = condColors(1:length(ROInum),1); end

for r = 1:length(ROInum)
% get relevant means/medians - X,Y,size
    subjM =[];
    for s = 1:length(subj)
        vox = subj(s).roi(ROInum(r)).fits(condNum).vox;
        if length(vox)==0
            mPars = nan(1,3);
            warning(sprintf('Missing %s ROI #%d!\n',subj(s).roi(ROInum(r)).fits(1).session,ROInum(r)));
        else
        eval(['mPars = ' whichM '(reshape([vox.params],length(vox(1).params),length(vox)),2);']);
        subjM(s,1) = mPars(2); subjM(s,2)=mPars(1);
        eval(['subjM(s,3) = nan' whichM '([vox.size]);']);
        end
    end


    meanVox = mean(subjM); steVox = std(subjM)/sqrt(size(subjM,1));
  
    se(1) = plotCircle(meanVox(1),meanVox(2),(meanVox(3)+steVox(3))*ppd/2,color(r,:),.5,'edge'); hold on; 
    se(2) = plotCircle(meanVox(1),meanVox(2),(meanVox(3)-steVox(3))*ppd/2,color(r,:),.5,'edge'); hold on;
    set(se,'LineWidth',1); hold on;%,'LineStyle','-.'); hold on;

    % plot mean/median pRF
    h(r) = plotCircle(meanVox(1),meanVox(2),meanVox(3)*ppd/2,color(r,:),1,'edge'); hold on;
    plot(meanVox(1),meanVox(2),'.','Color',color(r,:)); hold on;
    set(h(r),'Linewidth',2); hold on;
   
end

    %concentric circles at each dva
    for n = floor([0:1:(res/ppd)/2])
        a = plotCircle(res/2,res/2,n*ppd,[0 0 0],.75,'edge'); % center
        set(a,'Linewidth',1); hold on;
    end
    
    set(gca,'visible','off'); hline(res/2,'k--'); vline(res/2,'k--');
    axis([.5 res+.5 .5 res+.5]); axis square;
    
    if ~isempty(legText)
       try set(0,'DefaultLegendAutoUpdate','off'); catch 
       end
        g=legend([h],legText); set(g,'box','off','location','best');end
    
   %text(res*.6,res*.8,sprintf('Center of mass (X,Y) = [%g, %g]\n',round(meanVox(1)),round(meanVox(2))));

    if exist('plotCirc','var') && plotCirc>0
        hold on; a = plotCircle(res/2,res/2,plotCirc/2*ppd,[.5 .5 .5],1,'edge'); % center
        set(a,'Linewidth',3,'Linestyle',':'); hold on;
    end
%end

