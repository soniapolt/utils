function scatterErr(x,y,err,colors)
% function scatterErr(x,y,err,colors)
% scatterplot with nice colored errorbars
%clear all;
%x = [1:5]; y = rand([1,5]);err = .1* rand([1,5]); colors = roiColors(standardROIs(1:5));xlabels = standardROIs(1:5);

scatter(x,y,30,colors,'filled'); hold on;

for k = 1:length(y)
    e1 = errorbar(x(k),y(k),err(k),'LineStyle','None','LineWidth',2); hold on;
    set(e1,'Color',colors(k,:));
    set(e1,'MarkerEdgeColor',colors(k,:));
    e1.CapSize = 0;
end

end

