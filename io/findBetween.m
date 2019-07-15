function [inds] = findBetween(vals,lower,upper)
% return indices of values between A nd B
inds = intersect(find(vals>lower),find(vals<upper));
end

