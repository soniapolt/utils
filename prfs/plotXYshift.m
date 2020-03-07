function [angles, lengths] = plotXYshift(vox1,vox2,ppd,res,dotSize,plotOff,arrows)
% make a plot of position changes of pRFs, return the angle, length, and
% direction (toward or away from center) of shifts
% vox1/2 are struct vox.params (of standard pRF output)
% color is now determined based on angle of shift
% res = 330; ppd = 30;
% vox1 = bFits(3).vox; vox2 = bFits(1).vox;
if ~exist('arrows','var') arrows = 0; end
if ~exist('dotSize','var') dotSize = 5; end

scaleAlpha = 1;
if ~exist('plotOff','var')
    set(gca,'YDir','reverse');
    
    %concentric circles at each dva
    for n = floor([0:1:(res/ppd)/2])
        a = plotCircle(res/2,res/2,n*ppd,[0 0 0],.75,'edge'); % center
        set(a,'Linewidth',1); hold on;
    end
end

for v = 1:length(vox1)
    % calculate color
    XYstart = [vox1(v).params(2),vox1(v).params(1)];
    XYend = [vox2(v).params(2),vox2(v).params(1)];
    if scaleAlpha
    alph = nanmean([vox1(v).r2,vox2(v).r2]/100)-.25;
    if alph<0 alph = 0; end
    else alph = 1; end
    XYshift = XYend-XYstart;
    angles(v) = rad2deg(atan2(XYshift(2),XYshift(1)));
    lengths(v) = sqrt(XYshift(1).^2+XYshift(2).^2);
    
    %     if vox1(v).params(2),vox1(v).eccen < vox2(v).params(2),vox1(v).eccen
    %         eccenDir(v) = 1; % 1 is out
    %     else eccenDir(v) = -1; end
    if ~exist('plotOff','var')
        cmap = flipud(cmapang); % to account for our inverted axis
        cBin = ceil(angles(v)/360*length(cmap));
        
        if arrows
                    a = arrow(XYstart,XYend,...
            'EdgeColor',cmap(cBin,:),'FaceColor',cmap(cBin,:));
        arrow(a,'Length',4,'FaceAlpha',alph,'EdgeAlpha',alph);
        else
        
        a = line([XYstart(1) XYend(1)],[XYstart(2) XYend(2)],...
            'Color',[cmap(cBin,:) alph]);
        scatter(XYend(1),XYend(2),dotSize,cmap(cBin,:),'filled');
        end
    end
    
end

if ~exist('plotOff','var')
    set(gca,'Visible','off'); hline(res/2,'k--'); vline(res/2,'k--');
    axis([.5 res+.5 .5 res+.5]); axis square;
end
end


