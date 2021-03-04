function [lighter,steps] = lighter(colors,perc)
% function  [lighter,steps] = lighter(color,perc)
if ~exist('perc','var') perc = 50; end
%  using knk's colorinterpolate, give a lighter version of this color.
%  useful for opaque errorbars, outlines for visibility, etc.
% color = triplet, perc = percent white
for c = 1:size(colors,1)
steps = colorinterpolate([colors(c,:);white],100,0);
lighter(c,:) = steps(perc,:);
end
end

