function h = plotCoverage(vox,color,leg,ppd,res,plotSize,r2Gain,sampleVox,centerMass,plotCirc)
% function h = plotCoverage(vox,color,leg,ppd,res,plotSize,r2Gain,sampleVox,centerMass,plotCirc)
% vox is a structure of v voxels with  a params field
% plotting only uses kay params, so setting YDir to reseverse should be
% sufficient
% uses a few knkutils functions for the colorbar generation -
% https://github.com/kendrickkay/knkutils
% optional arguments:
% - alphaGain: scale color of pRFs by their gain, with colorbar; you'll
% probably want to use subplotresize.m afterwards
% - centerMass: plot a yellow star at the center of mass of X/Y
% - plotCirc: plot another size of some radius (in dva) (e.g. the size of our faces)

%set(gca,'YDir','reverse');
sizeCol = [.15 .15 .15]; % color for lines demarcating pRF size (currently black/white)

% set hem colors
if size(color,1) == 1; color = [color;color];end % no longer auto-color hemispheres %*.25]; end%

% default plot pRF size as an empty circle
if ~exist('plotSize','var'); plotSize = 1; end

%%%% sample a subset of voxels randomly
if exist('sampleVox','var') && sampleVox
    sv = randperm(length(vox));
    if sampleVox>length(sv) sampleVox = length(sv); end
    vox = vox(sv(1:sampleVox)); end

for v = 1:length(vox)
    if ~isfield(vox,'hem') vox(v).hem = 1; % hack for older prf sets - cannot do hem coloring
    end
    
    %%%% get alpha scaling for this voxel
%     if exist('alphaGain','var') && alphaGain % alpha scaling by the gain
%         a = vox(v).params(4); if a>5 a=5; end
%         a = a/5; % remember - alpha won't work on the linux machine for some reason!
%     else a = 1; end % no alpha scaling4
    if exist('r2Gain','var') && r2Gain % alpha scaling by the gain
        a = vox(v).r2/100;
        a = a/2; % remember - alpha won't work on the linux machine for some reason!
    else a = 1; end % no alpha scaling4
    
    %%%% pull out exponent to use for size calculation
    if length(vox(v).params)==5 % some flexibility for set-exponent models, but this ain't pretty.
        expN = vox(v).params(5);
    else expN = .2; end
    
    %%%% plot a circle to indicate pRF size; can be alpha-gain colored
    if plotSize
        h = plotCircle(vox(v).params(2),vox(v).params(1),2*vox(v).params(3)/sqrt(expN)/2,sizeCol,a,'edge'); % center
    hold on;
    end
    
    h = plot(vox(v).params(2),vox(v).params(1),'Marker','.','MarkerSize',15,'Color',color(vox(v).hem,:)); hold on;    
end

%%%% colorbar if we're using the alphaGain property
if exist('alphaGain','var') && alphaGain && plotSize
    cb = colormap(colorinterpolate([1 1 1;sizeCol],98,1));
    drawcolorbar(5.*[0 1],5.*[0:.2:1],cb,'gain',0); % since we set a/5 as the alpha level, rescale here
    set(gcf,'Renderer','Painters')
end


%%%% concentric circles at each dva
for n = floor([0:1:(res/ppd)/2])
    a = plotCircle(res/2,res/2,n*ppd,[0 0 0],.75,'edge'); % center
    set(a,'Linewidth',1); hold on;
end

%%%% axis corrections
set(gca,'visible','off'); hline(res/2,'k--'); vline(res/2,'k--');
axis([.5 res+.5 .5 res+.5]); axis square;
set(gca,'YDir','reverse');

%%%% legend
if ~isempty(leg)
    g=legend([h],leg); set(g,'box','off','location','best');end

%%%% mark center of mass of all coverage (with a star! and some text)
if exist('centerMass','var') && centerMass
    meanPars = mean(reshape([vox.params],length(vox(1).params),length(vox)),2);
    hold on; plot(meanPars(2),meanPars(1),'p','MarkerSize',20,'MarkerEdgeColor','w',...
        'MarkerFaceColor','y');
    text(res*.6,res*.8,sprintf('Center of mass (X,Y) = [%.2f, %.2f]\n',meanPars(2)/ppd,meanPars(1)/ppd));
end

%%%% plot a circle at the center (usually used to mark stim size)

if exist('plotCirc','var') && plotCirc>0
hold on; a = plotCircle(res/2,res/2,plotCirc*ppd,[0 0 .5],1,'edge'); % center
set(a,'Linewidth',3,'Linestyle','--'); hold on; 
end

end

