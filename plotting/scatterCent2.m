function s = scatterCent2(x,y,colors,xlab,ylab,titleTx,fontSize,equalLims,line,alpha)
% scatterplot with centroid & std - now like in manuscript, with lines at
% median
% if whichLine == 1, plot ID line; if whichLine == 2, plot lsqfit line

if ~exist('alpha','var')
    s = scatter(x,y,5,'k','filled'); hold on;
else
    hold on;
    s = scatterAlpha(x,y,alpha,'k',2); hold on;
end
% centroid & std

hold on;  h = hline(nanmean(y)); set(h,'Color',colors{1},'linestyle','-','linewidth',1.5);
hold on;  v = vline(nanmean(x)); set(v,'Color',colors{2},'linestyle','-','linewidth',1.5);

xlabel(xlab,'FontSize',fontSize);
y = ylabel(ylab,'FontSize',fontSize,'Interpreter','none');
title(titleTx,'fontSize',fontSize);

set(gca,'tickdir','out');
axis square; xx=get(gca,'xlim'); if exist('equalLims','var') && equalLims ylim(xx);end
hold on;

if exist('line','var')
    if line == 2
        h = lsline; set(h,'color',color);
    elseif line == 1
        plot(xx,xx,'k--'); end
    
end

