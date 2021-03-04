function [cmap] = body_colors(inds)
% facebody color map 
if ~exist('inds','var') inds = 1:4;end
cmap = [...
 10 20 120;...  % dark blue - pOTS bodies
 40 80 180;...  % light blue - OTS bodies]
 20 130 130; ... % teal - aOTs bodies
 80 170 125]...     % green -ATL bodies
 ./255; 
cmap = cmap(inds,:);
end