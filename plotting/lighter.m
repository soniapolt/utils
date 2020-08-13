function [lighter,steps] = lighter(color,perc)
% function  [lighter,steps] = lighter(color,perc)
if ~exist('perc','var') perc = 50; end
%  using knk's colorinterpolate, give a lighter version of this color.
%  useful for opaque errorbars, outlines for visibility, etc.
% color = triplet, perc = percent white
steps = colorinterpolate([color;white],100,0);
lighter = steps(perc,:);
end

