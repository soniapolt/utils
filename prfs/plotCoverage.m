function h = plotCoverage(vox,color,leg,ppd,res,sampleVox,alphaGain,centerMass,plotCirc)
% vox is a structure of v voxels with  a params field
% plotting only uses kay params, so seeting YDir to reseverse should be
% sufficient
% uses a few knkutils functions for the colorbar generation -
% https://github.com/kendrickkay/knkutils
% optional arguments:
% - alphaGain: scale color of pRFs by their gain, with colorbar; you'll
% probably want to use subplotresize.m afterwards
% - centerMass: plot a yellow star at the center of mass of X/Y
% - plotCirc: plot another size of some radius (in dva) (e.g. the size of our faces)

set(gca,'YDir','reverse');

if exist('sampleVox','var') && sampleVox
    sv = randperm(length(vox));
    if sampleVox>length(sv) sampleVox = length(sv); end
    vox = vox(sv(1:sampleVox)); end

for v = 1:length(vox)
    
    if exist('alphaGain','var') && alphaGain % alpha scaling by the gain
        a = vox(v).params(4); if a>5 a=5; end
        a = a/5;
    else a = 1; end % no alpha scaling
    h = plotCircle(vox(v).params(2),vox(v).params(1),2*vox(v).params(3)/sqrt(vox(v).params(5))/2,color,a,'edge'); % center
    hold on;
end
for v = 1:length(vox)
    plot(vox(v).params(2),vox(v).params(1),'k.'); hold on;
end

if exist('alphaGain','var') && alphaGain
    cb = colormap(colorinterpolate([1 1 1; color],98,1));
    drawcolorbar(5.*[0 1],5.*[0:.2:1],cb,'gain',0); % since we set a/5 as the alpha level, rescale here
end

%concentric circles at each dva
for n = floor([0:1:(res/ppd)/2])
    a = plotCircle(res/2,res/2,n*ppd,[0 0 0],.75,'edge'); % center
    set(a,'Linewidth',1); hold on;
end

set(gca,'visible','off'); hline(res/2,'k--'); vline(res/2,'k--');
axis([.5 res+.5 .5 res+.5]); axis square;
%set(gca,'YDir','reverse','fontSize',fontSize);
if ~isempty(leg)
    g=legend([h],leg); set(g,'box','off','location','best');end

if exist('centerMass','var') && centerMass
    meanPars = mean(reshape([vox.params],length(vox(1).params),length(vox)),2);
    hold on; plot(meanPars(2),meanPars(1),'p','MarkerSize',20,'MarkerEdgeColor','k',...
        'MarkerFaceColor','y');
    text(res*.6,res*.8,sprintf('Center of mass (X,Y) = [%g, %g]\n',round(meanPars(2)),round(meanPars(1))));
end

if exist('plotCirc','var') && plotCirc>0
hold on; a = plotCircle(res/2,res/2,plotCirc*ppd,[1 .5 .5],1,'edge'); % center
set(a,'Linewidth',3); hold on; 
end
end

