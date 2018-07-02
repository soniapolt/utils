function [hbar] = niceBars(x,data,errors,color)
hbar = bar(x, data); hold on;
errorbar(x, data,errors,'k','linestyle', 'none');% Plot with errorbars
set(hbar,'facecolor',color,'edgecolor','none');
end

