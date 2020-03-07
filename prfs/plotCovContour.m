function [areaDeg,boundary] = plotCovContour(covIm,res,ppd,color,showColorBar,plotCentroid)
% separating out the making (either via bootstrapping or other) and
% plotting of coverage
if ~exist('contourLines','var') contourLines = [.5 .6 .7 .8 .9 1]; end
if ~exist('color','var') || isempty(color) color = condColors(randi(20),1); end
if ~exist('plotCentroid','var') plotCentroid = 1; end

%covIm = flipud(covIm);

[c,h] = contour(covIm,repmat(max(covIm(:)),1,length(contourLines)).*contourLines,...
    'Color','w','LineWidth',1);

% label the levels 
h.LevelList= round(h.LevelList,3);  %rounds levels to 2nd decimal place
clabel(c,h,'LabelSpacing',2000,'Color','w');
 
set(gca,'visible','off'); colormap(colorinterpolate([1 1 1; color; 0 0 0],10,1)); %colormap('parula');%
caxis([0 1]);

%%% concentric circles at each dva
for n = floor([0:1:(res/ppd)/2])
     hold on;
     a = plotCircle(res/2,res/2,n*ppd,[0 0 0],.75,'edge'); % center
     set(a,'Linewidth',.5);
end

hold on; hline(res/2,'k'); hold on; vline(res/2,'k');

threshIm = im2bw(covIm,max(covIm(:))/2); % half-max of pRF coverage
areaDeg = sum(threshIm(:))/(ppd*ppd);


if plotCentroid
   props = regionprops(threshIm,covIm, 'WeightedCentroid'); 
try   
    centX = props(1).WeightedCentroid(1); centY = -props(1).WeightedCentroid(2); 
catch 
    centX = NaN; centY = NaN;
end
   plot(centX,-centY,'w.','MarkerSize',15);
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
