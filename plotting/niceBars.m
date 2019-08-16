function [hbar] = niceBars(x,data,errors,color)
hbar = bar(x, data); hold on;
h = errorbar(x, data,errors,'k','linestyle', 'none');% Plot with errorbars
if ~verLessThan('matlab','9.4') h.CapSize = 0; end % remove horizontal ticks on errobars

set(hbar,'facecolor',color,'edgecolor','none');
end

