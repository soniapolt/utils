function s = scatterCent(x,y,color,xlab,ylab,titleTx,fontSize,equalLims,line)
% scatterplot with centroid & std
% if whichLine == 1, plot ID line; if whichLine == 2, plot lsqfit line

s = scatter(x,y,10,'filled'); hold on;

% centroid & std

hold on;  errorbar2(nanmedian(x),nanmedian(y),nanstd(x)/sqrt(length(x)),'x','.-','Color',color*.5);%,'LineWidth',6,'MarkerSize',30);
hold on;  errorbar2(nanmedian(x),nanmedian(y),nanstd(y)/sqrt(length(y)),'y','.-','Color',color*.5);%,'LineWidth',6,'MarkerSize',30);
%

xlabel(xlab,'FontSize',fontSize);
y = ylabel(ylab,'FontSize',fontSize,'Interpreter','none');
title(titleTx,'fontSize',fontSize);

axis square; xx=get(gca,'xlim'); if exist('equalLims','var') && equalLims ylim(xx);end
hold on;

if exist('line','var')
    if line == 2
        h = lsline; set(h,'color',color);
    elseif line == 1
        plot(xx,xx,'k--'); end
    
end

