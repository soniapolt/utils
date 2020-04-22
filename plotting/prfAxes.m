function prfAxes(ppd,res,fov)
% function prfAxes(ppd,res,fov)
% sets up axes for retinotopic plots, e.g. prfRec output
if ~exist('fov','var') fov = 5; end

axis([-res/2/ppd res/2/ppd -res/2/ppd res/2/ppd]);set(gca,'YDir','reverse'); hline(0,'b:'); vline(0,'b:'); hold on; axis square;
xticks(-res/2/ppd:res/2/ppd); yticks((-res/2/ppd:res/2/ppd)); 
grid on; 
hold on; c = plotCircle(0,0,fov,'k',1,'edge'); set(c,'LineStyle',':');
end

