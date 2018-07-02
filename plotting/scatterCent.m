function s = scatterCent(x,y,color,xlab,ylab,titleTx,fontSize,leastLine)
% scatterplot with centroid & std
% if whichLine == 1, plot ID line; if whichLine == 2, plot lsqfit line

s = scatter(x,y,30,color); hold on;

% centroid & std

hold on; errorbar2(nanmean(x),nanmean(y),nanstd(x)/sqrt(length(x)),'x','m.-');%,'LineWidth',6,'MarkerSize',30);
hold on; errorbar2(nanmean(x),nanmean(y),nanstd(y)/sqrt(length(y)),'y','m.-');%,'LineWidth',6,'MarkerSize',30);
%

xlabel(xlab,'FontSize',fontSize);
y = ylabel(ylab,'FontSize',fontSize,'Interpreter','none');
title(titleTx,'fontSize',fontSize);

axis square; xx=get(gca,'xlim'); 
hold on; 
if exist('leastLine','var')
h = lsline; set(h,'color',color);    
else 
plot(xx,xx,'k--'); end

end

