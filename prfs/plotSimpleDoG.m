function [DoG,xx,yy] = plotSimpleDoG(res,pp,norm,subplotNum)
% based on KK function:
% function [f,xx,yy] = makegaussian2d(res,r,c,sr,sc,xx,yy,ang,omitexp)
% modified by SP 3/2018
% simple == not CSS
% norm 0 == no normalization
% norm 1 = L1 normalization of the positive component applied to both the
% positive and negative components
%
% <res> is the number of pixels along one side
% <y or r> is the row associated with the peak of the Gaussian (can be a decimal).
%   if [], default to the exact center of the image along the vertical dimension.
% <x or c> is the column associated with the peak of the Gaussian (can be a decimal).
%   if [], default to the exact center of the image along the horizontal dimension.
% <SD> is the standard deviation of the center gaussian
% <negSD> is the ADDNTL standard deviation of the center gaussian. it's
% added to the SD, so that the surround is always bigger than the center
% <ampRatio> is the ratio of surround/center amplitude, with center == 1

%
% example:
% makeSimpleDoG(32,16.5,16.5,4,6,.5);

% sample input
% close all; clear all;
% res = 20;
% y = (1+res)/2;
% x = (1+res)/2;
% SD = 5;
% negSD = 10;
% ampRatio = .2;

y=pp(1); x=pp(2); SD=pp(3); negSD=pp(4); amp=pp(5); ampRatio=pp(6); 

% construct coordinates
if ~exist('xx','var') || isempty(xx)
  [xx,yy] = calcunitcoordinates(res);
end

% convert to the unit coordinate frame
yc = (-1/res) * y + (.5 + .5/res); 
xc = (1/res) * x + (-.5 - .5/res);  
negSD = (SD+negSD)/res; resSD = SD/res; 

% construct coordinates (see makegabor2d.m)
coord = [flatten(xx-xc); flatten(yy-yc)];

center = reshape(exp((coord(1,:).^2+coord(2,:).^2)/-(2*resSD^2)),size(xx));

if norm == 1 
    posNorm = 1/(2*pi*SD*SD); % make sure this is the unscaled SD!
else posNorm = 1;
end

center = center*posNorm;
surround = reshape(-ampRatio*posNorm*exp((coord(1,:).^2+coord(2,:).^2)/-(2*negSD^2)),size(xx));
 
DoG = center+surround;

% figure;
subplot(subplotNum(1),subplotNum(2),subplotNum(3));
plot(center(:,round(x)),'r');
hold on; plot(surround(:,round(x)),'b');
hold on; plot(DoG(:,round(x)),'k:');
l = legend({'center' 'surround' 'DoG'});
set(l,'location','NorthEast','FontSize',10,'box','off');

%set(gca,'visible','off');

% L1 normalization of the entire DoG
% DoG = DoG/[(2*pi*(SD*res)^2)-(2*pi*ampRatio*(negSD*res)^2)];


