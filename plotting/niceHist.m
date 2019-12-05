function niceHist(data,color,plotMed)
% well-colored histogram plot with option to plot a line at its median;
% default plots a line at 0

hold on; hist(data,100); axis square;
h = findobj(gca,'Type','patch');
set(h,'FaceColor',color,'FaceAlpha',.5,'EdgeAlpha',0);
set(gca,'box','off','color','none');

if exist('plotMed','var')
vv = vline(nanmedian(data),'k:',['Med = ' num2str(nanmedian(data))]); set(vv,'Color',color,'LineWidth',2);
end
v = vline(0,'k:'); set(v,'LineWidth',2);

end

