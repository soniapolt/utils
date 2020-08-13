function [areaDeg,centX, centY] = plotCovIm(covIm,res,ppd,showColorBar,plotCentroid,contourLines)
% separating out the making (either via bootstrapping or other) and
% plotting of coverage

if ~exist('plotCentroid','var') plotCentroid = 0; end
if ~exist('contourLines','var') contourLines = [.5 .75 .875]; end
covIm = flipud(covIm); % fixes Y-axis discrepancy between prf fitting codes and matlab's plotting functions

imshow(covIm);

set(gca,'visible','off'); colormap(mrvColorMaps('jet'));%('parula');%

%%% concentric circles at each dva
for n = floor([0:1:(res/ppd)/2])
     hold on;
     a = plotCircle(res/2,res/2,n*ppd,[0 0 0],.75,'edge'); % center
     set(a,'Linewidth',.5);
end

hold on; hline(res/2,'k'); hold on; vline(res/2,'k');

threshIm = im2bw(covIm,max(covIm(:))/2); % half-max of pRF coverage
areaDeg = sum(threshIm(:))/(ppd*ppd);
%b = bwboundaries(threshIm,4,'noholes');
% for k=1:length(b)
%     boundary = b{k}; hold on;
% p = plot(boundary(:,2), boundary(:,1), 'Color','w','LineWidth',4);end

hold on;  contour(covIm,repmat(max(covIm(:)),1,length(contourLines)).*contourLines,...
    'Color','w','LineWidth',1); %clabel(c,h);

if plotCentroid
   %threshIm = im2bw(covIm,0); 
   props = regionprops(threshIm,covIm, 'WeightedCentroid'); 
try   
    centX = props(1).WeightedCentroid(1); centY = props(1).WeightedCentroid(2); 
catch 
    centX = NaN; centY = NaN;
end
   plot(centX,centY,'w.','MarkerSize',5);
else centX = NaN; centY = NaN;
end

axis square;

% colorbar placement
if exist('showColorBar','var') && showColorBar
pos = get(gca,'Position'); %[left, bottom, width, height].
barpos =  [pos(1)+pos(3)+.005, pos(2), .005, pos(4)];
c = colorbar('FontSize',10,'Box','off','Position',barpos);
end
brighten(-.5);
end

