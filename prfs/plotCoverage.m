function h = plotCoverage(vox,color,leg,ppd,res)
% vox is a structure of v voxels with  a params field
% plotting only uses kay params, so seeting YDir to reseverse should be
% sufficient
set(gca,'YDir','reverse');
    for v = 1:length(vox)
        h = plotCircle(vox(v).params(2),vox(v).params(1),2*vox(v).params(3)/sqrt(vox(v).params(5))/2,color,1,'edge'); % center
        hold on;
    end
    for v = 1:length(vox)
        plot(vox(v).params(2),vox(v).params(1),'k.'); hold on;
    end
    
    %concentric circles at each dva
    for n = floor([0:1:(res/ppd)/2])
        a = plotCircle(res/2,res/2,n*ppd,[0 0 0],.75,'edge'); % center
        set(a,'Linewidth',1); hold on;
    end
    
    set(gca,'visible','off'); hline(res/2,'k--'); vline(res/2,'k--');
    axis([.5 res+.5 .5 res+.5]); axis square;
    %set(gca,'YDir','reverse','fontSize',fontSize);
    if ~isempty(leg)
    g=legend([h],leg); set(g,'box','off','location','best');end
end

