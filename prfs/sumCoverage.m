
function coverage = sumCoverage(vox,ppd,res,setScale,plotCenters)
% vox is a structure of v voxels with  a params field

% load('/Volumes/invPRF/cssFit/fits/SP180625/photo/SP180625_f_rh_IOG_faces_cssShift.mat')
% vox = fits(1).vox; ppd = fits(1).ppd; res= fits(1).res;
% vox = readPRFs(vox,ppd,res);
% plotCenters = 1;

[X,Y]=meshgrid(-res/2:res/2,-res/2:res/2);

coverage = [];
for v = 1:length(vox)
    coverage(v,:,:) = PRF(X,Y,vox(v).XYdeg(1)*ppd,vox(v).XYdeg(2)*ppd,vox(v).size*ppd);
end

% to deal with the issue of plot/imagesc using different coordinate systems
covIm = flipud(squeeze(mean(coverage)));

if isempty(setScale)
imagesc(covIm);
else imshow(covIm,setScale);
end

set(gca,'visible','off'); colormap(mrvColorMaps('hot'));%('parula');%

%%% concentric circles at each dva
for n = floor([0:1:(res/ppd)/2])
     hold on;
     a = plotCircle(res/2,res/2,n*ppd,[0 0 0],.75,'edge'); % center
     set(a,'Linewidth',.5);
end
hold on; hline(res/2,'k--'); hold on; vline(res/2,'k--');

%%% plot pRF centers and half-max coverage
if exist('plotCenters','var')
    for v = 1:length(vox)
    plot(vox(v).params(2),vox(v).params(1),'w.'); hold on;
    end
end

threshIm = im2bw(covIm,max(covIm(:))/2); % half-max of pRF coverage
b = bwboundaries(threshIm,4,'noholes');
for k=1:length(b)
    boundary = b{k}; hold on;
plot(boundary(:,2), boundary(:,1), 'w','LineWidth',2);end

axis square;

% colorbar placement
pos = get(gca,'Position'); %[left, bottom, width, height].
barpos =  [pos(1)+pos(3)+.005, pos(2), .005, pos(4)];
c = colorbar('FontSize',10,'Box','off','Position',barpos);