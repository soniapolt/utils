function [reps,counts,repInds] = findRepeats(a,cutoff)
% function [reps,counts,repInds] = findRepeats(a,cutoff)
% looks through array a, finds values that have >= cutoff-N repetitions,
% returns their values, counts, and indices
if ~exist('cutoff','var') cutoff = 2; end

%a = [9 9 9 9 9 9 8 8 8 8 7 7 7 6 6 6 5 5 4 2 1]

[c,ia,ic] = unique(a,'stable');

% returns C = A(IA) and A = C(IC)
%c = [9 8 7 6 5 4 2 1]
%ia = [1 7 11 14 17 19 20 21]'
%ic = [1 1 1 1 1 1 2 2 2 2 3 3 3 4 4 4 5 5 6 7 8]'


[n,edges] = histcounts(ic,[min(ic):max(ic)]);

reps = c(edges(find(n>=cutoff)));
counts = n(find(n>=cutoff));

[repInds] = find(ismember(a,reps));

end

