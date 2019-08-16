function [sd1,sd2] = subplotDims(totalPlots,maxCol,maxRow)
% function [sd1,sd2] = subplotDims(totalPlots)
% breaks total number of plots into some reasonable number of subplots
% sorts by either max row or max colum, depending on which variable you
% give it (other should be empty [])
% default to maxCol = 5;

if ~exist('maxCol','var') maxCol = 5; end

if ~isempty(maxCol)
    if maxCol<totalPlots sd2 = maxCol; else sd2 = totalPlots; end
    sd1 = ceil(totalPlots/maxCol);
elseif ~isempty(maxRow)
    if maxRow<totalPlots sd1 = maxRow; else sd1 = totalPlots; end
    sd2 = ceil(totalPlots/maxRow);
end

end

