function prfRec_plot(metric,metricName,labels,order)
% function plotPerf(perf)
% simple session performance barplot
if ~exist('labels','var')
labels = {'Low' 'Center' 'Up'}; end
if ~exist('order','var')
order = [4 5 6 1 2 3]; end % this is correct for prfRec2 but not prfRec1

hbar = bar([metric([order(1:3)]);metric([order(4:6)])]','grouped'); hold on;
set(gca,'xticklabel',labels,'box','off','FontSize',12);
xlabel('Position');ylabel(metricName);%title(metricName)
legend({'Upright' 'Inverted'},'box','off','Location','NorthEastOutside');

% beauty and grace
set(hbar,'edgecolor','none');set(gcf,'color',[1 1 1]);
end

