function niceHist(data,color,plotMean)
% well-colored histogram plot with option to plot a line at its mean;
% default plots a line at 0

hold on; hist(data,100); axis square;
h = findobj(gca,'Type','patch');
set(h,'FaceColor',color,'FaceAlpha',.5,'EdgeAlpha',0);
set(gca,'box','off','color','none');

if exist('plotMean','var')
vv = vline(nanmean(data),'k:',num2str(nanmean(data))); set(vv,'Color',color,'LineWidth',2);
end
v = vline(0,'k:');

end

