function [centX,centY,bw] = weightedCent(im,thresh)
% function [centX,centY] = weightedCent(im)
% calculating weighted centroid of a full image
if ~exist('thresh','var') bw = ones(size(im)); 
else bw = thresh;end
   props = regionprops(bw,im, 'WeightedCentroid'); 
try   
    centX = props(1).WeightedCentroid(1); centY = props(1).WeightedCentroid(2); 
catch 
    centX = NaN; centY = NaN;
end
   plot(centX,centY,'g*','MarkerSize',10);
end

