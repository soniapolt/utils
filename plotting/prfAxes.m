function prfAxes(ppd,res,fov)
% sets up axes for retinotopic plots, e.g. prfRec output
if ~exist('fov','var') fov = 4.5; end

axis([-res/2/ppd res/2/ppd -res/2/ppd res/2/ppd]);set(gca,'YDir','reverse'); hline(0,'b:'); vline(0,'b:'); hold on; axis square;
grid on; 
% try
%     xticks(-res/2/ppd:res/2/ppd); yticks(fliplr(-res/2/ppd:res/2/ppd));
% catch 
%     set(gca,'XTick',-res/2/ppd:res/2/ppd);set(gca,'YTick',fliplr(-res/2/ppd:res/2/ppd));
% end
hold on; c = plotCircle(0,0,fov,'k',1,'edge'); set(c,'LineStyle',':');
end

