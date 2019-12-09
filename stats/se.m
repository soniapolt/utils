function [se,n] = se(data)
% standard error
n = length(data);
se = nanstd(data)/sqrt(n);
end

