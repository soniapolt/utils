function [hbar] = niceBars_colValue(x,data,errors,cmin,cmax,cmap)
% function [hbar] = niceBars_colValue(x,data,errors)
% color bars by their value - for now, only a brightened jet colormap to
% correspond to coverage maps for pRFs
% features to add: errorbar color handling.
% SP 3/9/20

if ~exist('cmin','var') cmin = 0; end
if ~exist('cmax','var') cmax = 1; end
if ~exist('cmap','var'); cmap = brighten(colormap('jet'),.5); end
caxis([cmin cmax]);


colors = cmaplookup(data,cmin,cmax,0,cmap);

hbar = bar(x, data,.33,'FaceColor','flat'); hold on;
hbar.CData = colors;
hbar.EdgeColor =  'None';
h = errorbar(x, data,errors,'k','linestyle', 'none');% Plot with errorbars
h.CapSize = 0; 


colormap(cmap);colorbar;caxis([cmin cmax]);
end

