function s = scatterCent(x,y,color,xlab,ylab,titleTx,fontSize,equalLims,leastLine)
% scatterplot with centroid & std
% if whichLine == 1, plot ID line; if whichLine == 2, plot lsqfit line

s = scatter(x,y,30,color); hold on;

% centroid & std

hold on; errorbar2(nanmedian(x),nanmedian(y),nanstd(x)/sqrt(length(x)),'x','b.-');%,'LineWidth',6,'MarkerSize',30);
hold on; errorbar2(nanmedian(x),nanmedian(y),nanstd(y)/sqrt(length(y)),'y','b.-');%,'LineWidth',6,'MarkerSize',30);
%

xlabel(xlab,'FontSize',fontSize);
y = ylabel(ylab,'FontSize',fontSize,'Interpreter','none');
title(titleTx,'fontSize',fontSize);

axis square; xx=get(gca,'xlim'); %if ~exist('equilLims','var') || equilLims ylim(xx);end
hold on; 
if exist('leastLine','var')
h = lsline; set(h,'color',color);    
else 
plot(xx,xx,'k--'); end

end

