
function [PRF] = PRF(x,y,muX,muY,sigma)
% PRF formula  - standard gaussian
PRF = exp(-((x-muX).^2 + (y-muY).^2)/(2*sigma^2));
end