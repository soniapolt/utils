function [hbar] = niceGroupedBars(data,errors,groups,legText)
% grouped bars with errors, for matlab 2014a

hBar = bar(data);
for c = 1:size(data,2)
    set(hBar(c),'facecolor',condColors(c),'edgecolor','none');
end

if ~isempty(errors)
    hold on;
    for k = 1:length(hBar)                    % Loop: Plots Error Bars
        midbar = mean(get(get(hBar(k),'Children'), 'XData'));
        errorbar(midbar, data(:,k), errors(:,k), 'k','linestyle','none'); hold on; % plotting errors
    end
end
set(gca,'box','off','color','none');

if exist('legend','var')
    legend(legText,'location','NorthEast','FontSize',10,'box','off');
end

if exist('groups','var')
   set(gca,'XTickLabel',groups,'FontSize',10,'FontWeight','bold');
   %xticklabel_rotate(1:length(groups),45,groups,'fontsize',14, 'fontweight','bold','interpreter','none');
end

end

