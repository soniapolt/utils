function [degVal,ppd] = pix2deg(pixVal,pixWidth,cmWidth,viewDist)
% function [degVal,ppd] = pix2deg(pixVal,pixWidth,cmWidth,viewDist)
% conversion from pixel to degree values
% inputs: pixel value, width of screen in pixels (usually rect(3)), and
% measured viewing distances
ppd = pi* pixWidth / (atan(cmWidth/viewDist/2)) / 360;
degVal = pixVal/ppd;
end

