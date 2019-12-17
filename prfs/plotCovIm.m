function [areaDeg] = plotCovIm(covIm,res,ppd,showColorBar,dontScale)
% separating out the making (either via bootstrapping or other) and
% plotting of coverage

covIm = flipud(covIm); % fixes Y-axis discrepancy between prf fitting codes and matlab's plotting functions
    
if ~exist('dontScale','var') || ~dontScale
imagesc(covIm);
else imshow(covIm);
end

set(gca,'visible','off'); colormap(mrvColorMaps('jet'));%('parula');%

%%% concentric circles at each dva
for n = floor([0:1:(res/ppd)/2])
     hold on;
     a = plotCircle(res/2,res/2,n*ppd,[0 0 0],.75,'edge'); % center
     set(a,'Linewidth',.5);
end

hold on; hline(res/2,'k--'); hold on; vline(res/2,'k--');

% %%% plot pRF centers and half-max coverage
% if exist('plotCenters','var') && plotCenters
%     for v = 1:length(vox)
%     plot(vox(v).params(2),vox(v).params(1),'k.'); hold on;
%     end
% end

threshIm = im2bw(covIm,max(covIm(:))/2); % half-max of pRF coverage
areaDeg = sum(threshIm(:))/(ppd*ppd);
b = bwboundaries(threshIm,4,'noholes');
for k=1:length(b)
    boundary = b{k}; hold on;
plot(boundary(:,2), boundary(:,1), 'Color','w','LineWidth',1);end

axis square;

% colorbar placement
if exist('showColorBar','var') && showColorBar
pos = get(gca,'Position'); %[left, bottom, width, height].
barpos =  [pos(1)+pos(3)+.005, pos(2), .005, pos(4)];
c = colorbar('FontSize',10,'Box','off','Position',barpos);
end
end

