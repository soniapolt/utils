function niceHist(data,colors,plotMed)
% function niceHist(data,colors,plotMed)
% data should be size (observations, group) or vector
% well-colored histogram plot with option to plot a line at its median;
% default plots a line at 0
% now lets us plot multiple histograms on the same axis
if size(data,1) == 1 data = data'; end
if~exist('colors','var'); colors = black; end

for c = 1:size(data,2)
hold on; hist(data(:,c),100);
h = findobj(gca,'Type','patch');
set(h(1),'FaceColor',colors(c,:),'FaceAlpha',.6,'EdgeAlpha',0);

if exist('plotMed','var') && plotMed
vv = vline(nanmedian(data(:,c)),'k:',['Med = ' num2str(nanmedian(data(:,c)))]); 
if length(colors) > 1 set(vv,'Color',colors(c,:),'LineWidth',2); else
    set(vv,'LineWidth',2); end

end

end
set(gca,'box','off','color','none'); axis square;
%v = vline(0,'k:'); set(v,'LineWidth',2);

end

