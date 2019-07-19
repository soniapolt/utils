function prfRec_plot(metric,metricName)
% function plotPerf(perf)
% simple session performance barplot
labels = {'0' '-0.5' '-1'};

hbar = bar([metric(4:6);metric(1:3)]','grouped'); hold on;
set(gca,'xticklabel',labels,'box','off','FontSize',12);
xlabel('Position');ylabel(metricName);title(metricName)
legend({'Upright' 'Inverted'},'box','off','Location','NorthEastOutside');

% beauty and grace
set(hbar,'edgecolor','none');set(gcf,'color',[1 1 1]);
end

