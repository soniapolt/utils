function [s] = scatterAlpha(x,y,a,color,dotSize)
% function [s] = scatterAlpha(x,y,a,color,dotSize)
% allows scatterplot to have an alpha value assigned to every dot, e.g. for
% coloring things by r2

if ~exist('a','var') a = ones(1,length(x)); end
if ~exist('dotSize','var') dotSize = 2; end
if ~exist('color','var') color = 'k'; end

%ax = axes;
%hold on;
for i = 1:length(x)
  s(i) = scatter(x(i),y(i),dotSize,color,'filled');
  s(i).MarkerFaceAlpha = a(i);  %%marking every maker with different alpha value
end

end

