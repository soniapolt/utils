function [CIval,med] = CI(dist,perc)
% function [CI,med] = CI(dist,perc)
% confidence interval from values in dist, default 68%
if ~exist('perc','var') || isempty(perc) perc = 68; end

ordered = sort(dist);
CIval(1,:) = prctile(ordered, 50-perc/2);
CIval(2,:) = prctile(ordered, 50+perc/2);
med = prctile(ordered,50);
end

