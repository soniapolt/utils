function [cbar] = addColorBar(ticks,label)
%Uadd colorbar to plot flexibly
if ~exist('label','var') label = '';end
matVer = version;
if str2num(matVer(end-2)) >5
    cbar = colorbar('Ticks',ticks); cbar.Label.String= label;
else cbar = colorbar('YTick',ticks); ylabel(cbar,label);
end
end

