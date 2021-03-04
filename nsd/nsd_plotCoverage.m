function h = nsd_plotCoverage(vox,color,leg,plotSize,r2Gain,sampleVox,centerMass,plotRect)
% function h = plotCoverage(vox,color,leg,ppd,res,plotSize,r2Gain,sampleVox,centerMass,plotCirc)
% vox is a structure of v voxels with Xdeg,Ydeg fields
% as in nsddata cssfits, assumes conversion to degrees
% uses a few knkutils functions for the colorbar generation -
% https://github.com/kendrickkay/knkutils
% optional arguments:
% - alphaGain: scale color of pRFs by their gain, with colorbar; you'll
% probably want to use subplotresize.m afterwards
% - centerMass: plot a yellow star at the center of mass of X/Y
% - plotCirc: plot another size of some radius (in dva) (e.g. the size of our faces)

maxEccen = 5;   % for polar plots

%set(gca,'YDir','reverse');
sizeCol = [.15 .15 .15]; % color for lines demarcating pRF size (currently black/white)

% set hem colors
if size(color,1) == 1; color = [color;color*.25];end %  auto-color hemispheres

% default plot pRF size as an empty circle
if ~exist('plotSize','var'); plotSize = 1; end

%%%% sample a subset of voxels randomly
if exist('sampleVox','var') && sampleVox > 0
    sv = randperm(length(vox));
    if sampleVox>length(sv) sampleVox = length(sv); end
    vox = vox(sv(1:sampleVox)); end

for v = 1:length(vox)

    if exist('r2Gain','var') && r2Gain % alpha scaling by the gain
        a = vox(v).r2/100;
        a = a/2; % remember - alpha won't work on the linux machine for some reason!
    else a = 1; end % no alpha scaling
    
    %%%% plot a circle to indicate pRF size; can be alpha-gain colored
    if plotSize
        h = plotCircle(vox(v).Xdeg,vox(v).Ydeg,vox(v).size,sizeCol,a,'edge'); % center
    hold on;
    end
    
    h = plot(vox(v).Xdeg,vox(v).Ydeg,'Marker','.','MarkerSize',15,'Color',color(vox(v).hem,:)); hold on;    
end


%%%% concentric circles at each dva
for n = [0:1:maxEccen]
    a = plotCircle(0,0,n,[0 0 0],.75,'edge'); % center
    set(a,'Linewidth',1); hold on;
end

%%%% axis corrections
set(gca,'visible','off'); hline(0,'k--'); vline(0,'k--');
axis([-maxEccen maxEccen -maxEccen maxEccen]); axis square;

%%%% legend
if ~isempty(leg)
    g=legend([h],leg); set(g,'box','off','location','best');end

%%%% mark center of mass of all coverage (with a star! and some text)
if exist('centerMass','var') && centerMass
    hold on; plot(nanmean([vox.Xdeg]),nanmean([vox.Ydeg]),'p','MarkerSize',20,'MarkerEdgeColor','w',...
        'MarkerFaceColor','k');
    text(maxEccen*.6,maxEccen*.6,sprintf('Center of mass (X,Y) = [%.2f, %.2f]\n',nanmean([vox.Xdeg]),nanmean([vox.Ydeg])));
end

%%%% plot a square at the center (usually used to mark stim size)

if exist('plotRect','var') && plotRect>0
hold on; a = rectangle('Position',[-4.2 -4.2 8.4 8.4]);
set(a,'Linewidth',2,'Linestyle','--');
end

end

