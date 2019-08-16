function [hbar] = niceGroupedBars(data,error,groupNames,barNames)
% grouped bars with errors, for matlab 2014a
% data = m x n matrix where M is groups and N is bars within each group
% error = matrix of size error

%data =[69,123; 74, 62; 47 68]; error = [3, 3; 1, 3; 6,7];

hBar = bar(data);
for c = 1:size(data,2)
    set(hBar(c),'facecolor',condColors(c),'edgecolor','none');
end

if ~isempty(error)
nGrp = size(data, 1);
nBars = size(data, 2);
% Calculating the width for each bar group
grpW = min(0.8, nBars/(nBars + 1.5));
for i = 1:nBars
    x = (1:nGrp) - grpW/2 + (2*i-1) * grpW / (2*nBars);
    hold on; h = errorbar(x, data(:,i), error(:,i), 'k.');
    if ~verLessThan('matlab','9.4') h.CapSize = 0; end % remove horizontal ticks on errobars
end
end

set(gca,'box','off','color','none');

if exist('barNames','var')
    legend(barNames,'location','NorthEast','FontSize',10,'box','off');
end

if exist('groupNames','var')
   set(gca,'XTickLabel',groupNames,'FontSize',10,'FontWeight','bold');
   %xticklabel_rotate(1:length(groups),45,groups,'fontsize',14, 'fontweight','bold','interpreter','none');
end


