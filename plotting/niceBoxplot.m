function b = niceBoxplot(data,labels,plotMed,colors,cutY)
% colors needs to be in n-by-3 matrix
% plotMed will label the medians
% cutY sets a ylimit
axis square;

if ~exist('colors','var')
    colors = [condColors(1); condColors(2)]; end


b = boxplot(data,'labels',labels,'plotstyle','traditional','outliersize',.5,'jitter',.1);%,'ColorGroup',colors);
c = findobj(gca,'tag','Median'); b = findobj(gca,'tag','Box');
for x = 1:length(c) set(c(x),'Color',colors(x,:)); set(b(x),'Color',colors(x,:)); end

h = findobj(gca,'tag','Outliers');
set(h,'MarkerEdgeColor',[.5 .5 .5]);

if exist('cutY','var') && ~isempty(cutY)
    ylim(cutY); end


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

