function [weightedIms] = weightIms(imMatrix,weightVector)
% function [scaledIms] = scaleIms(imMatrix,scaleVector)
% scaling image matrix (nxmxp) by a vector of weights (1xp)
weightedIms = bsxfun(@times,imMatrix,reshape(weightVector,1,1,length(weightVector)));
end

