function [cmap] = redblue
% [cmap] = redblue
%   using knk utils to build a red/white/blue colormap for e.g. relevance
%   mapping
cmap = colormap(colorinterpolate([0 0 1; 1 1 1; 1 0 0],100,1));
end

