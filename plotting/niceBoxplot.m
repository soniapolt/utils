function b = niceBoxplot(data,labels,plotMed,colors,cutY,plotData)
% colors needs to be in n-by-3 matrix
% plotMed will label the medians
% cutY sets a ylimit
axis square;

if ~exist('colors','var')
    colors = [condColors(1); condColors(2)]; end
if ~exist('plotData','var') plotData = 0; end

b = boxplot(data,'labels',labels,'plotstyle','traditional','outliersize',.5,'jitter',.1,'widths',.3);%,'ColorGroup',colors);
c = findobj(gca,'tag','Median'); d = findobj(gca,'tag','Box');
e = findobj(gca,'tag','Upper Whisker'); f = findobj(gca,'tag','Lower Whisker'); 

for x = 1:length(c) 
    set(c(x),'Color',colors(x,:)); set(d(x),'Color',colors(x,:)); 
    set(e(x),'LineStyle','-','Color',colors(x,:)*.5); 
    set(f(x),'LineStyle','-','Color',colors(x,:)*.5); 
end

delete(findobj(gca,'Tag','Upper Adjacent Value'));delete(findobj(gca,'Tag','Lower Adjacent Value'));

if plotData 
   hold on; plot(1:size(data,2),data,'k.')
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

