function [ib] = cellNum(string,wholeSet)
% more intuitive way to find the number of specific cell vals (like ROIs or
% subject numbers) in an array (like all of the possible ROIs)
[C,ia,ib] = intersect(string,wholeSet, 'stable');
end

