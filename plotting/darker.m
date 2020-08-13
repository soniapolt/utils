function [darker,steps] = darker(color,perc)
% function  [lighter,steps] = lighter(color,perc)
if ~exist('perc','var') perc = 50; end
%  using knk's colorinterpolate, give a darker version of this color.
%  useful for opaque errorbars, outlines for visibility, etc.
% color = triplet, perc = percent BLACK
steps = colorinterpolate([color;black],100,0);
darker = steps(perc,:);
end

