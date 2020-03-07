function [centX,centY] = FWHMcentroid(im,threshVal)
% function [centX,centY] = FWHMcentroid(im,val)
% determines weighted centroid of PRF coverage images, default to FWHM (val
% = .5) but can be set otherwise. val = 0 will be whole image
if ~exist('threshVal','var') threshVal = .5; end

threshIm = im2bw(im,max(im(:))*threshVal); % half-max of pRF coverage
props = regionprops(threshIm,im, 'WeightedCentroid');
try centX = props(1).WeightedCentroid(1); centY = -props(1).WeightedCentroid(2);
catch centX = NaN; centY = NaN;end

end

