function b = niceBoxplot2(data,labels,plotMed,dotColors,cutY,plotData)
% colors needs to be in n-by-3 matrix
% plotMed will label the medians
% cutY sets a ylimit
% version 2 is manuscript coloring

colors = repmat([white*.3;white*.8],size(data,2),1);

if ~exist('plotData','var') plotData = 0; end


b = boxplot(data,'labels',labels,'plotstyle','traditional','outliersize',.5,'jitter',.1,'widths',.3);%,'ColorGroup',colors);
c = findobj(gca,'tag','Median'); d = findobj(gca,'tag','Box');
e = findobj(gca,'tag','Upper Whisker'); f = findobj(gca,'tag','Lower Whisker'); 

% fringe case where we're plotting two hems on the same axis
if length(c) == 2*length(colors)
    colors = [colors; colors]; end

% non-filled bars
for x = 1:length(c) 
    set(d(x),'Color',colors(x,:),'LineWidth',.5); 
    %patch(get(d(x),'XData'),get(d(x),'YData'),'Color','None');
    set(c(x),'Color',colors(x,:)*.8,'LineWidth',.3);
    set(e(x),'LineStyle','-','Color',colors(x,:),'LineWidth',.2); 
    set(f(x),'LineStyle','-','Color',colors(x,:),'LineWidth',.2); 
end

% filled light/dark grey bars
% for x = 1:length(c) 
%     set(d(x),'LineStyle','none'); 
%     patch(get(d(x),'XData'),get(d(x),'YData'),colors(x,:),'FaceAlpha',1,'LineStyle','none');
%     set(c(x),'Color',black);
%     set(e(x),'LineStyle','-','Color',black,'LineWidth',.2); 
%     set(f(x),'LineStyle','-','Color',black,'LineWidth',.2); 
% end

delete(findobj(gca,'Tag','Upper Adjacent Value'));delete(findobj(gca,'Tag','Lower Adjacent Value'));

if plotData 
   hold on; scatter(Expand(1:size(data,2),size(data,1),1)',reshape(data,[],1),3,flipud(Expand(dotColors,1,size(data,1))),'filled')
end

h = findobj(gca,'tag','Outliers');
set(h,'MarkerEdgeColor',[.5 .5 .5]);

if exist('cutY','var') && ~isempty(cutY)
    ylim([cutY]); end


set(gca,'box','off','color','none');
if exist('plotMed','var') && plotMed
    m = findobj(gca,'tag','Median');
    m= flipud(m);
    for s = 1:length(labels)
        med = get(m(s),'YData');
        txt = [labels{s} ' = ' num2str(med(1))];
        yl = ylim;
        t = text(s+.1,yl(1)+(yl(2)*.1*s),txt); set(t,'Color','k','FontSize',12);
    end
end

end

