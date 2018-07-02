function [angles, lengths, sign] = plotXYshift2(vox1,vox2,ppd,res,plotOff)
% make a plot of position changes of pRFs, return the angle, length, and
% direction (toward or away from center) of shifts
% vox1/2 are struct vox.params (of standard pRF output)
% color is now determined based on angle of shift
% res = 330; ppd = 30;
% vox1 = bFits(3).vox; vox2 = bFits(1).vox;
% version 2 also calculates if the shift is to or from the center - sign -1
% is toward center, sign +1 is away from center

if ~exist('plotOff','var');
    set(gca,'YDir','reverse');
    
    %concentric circles at each dva
    for n = floor([0:1:(res/ppd)/2])
        a = plotCircle(res/2,-res/2,n*ppd,[0 0 0],.75,'edge'); % center
        set(a,'Linewidth',1); hold on;
    end
end

center = [res/2 res/2];
for v = 1:length(vox1)
    % calculate color
    XYstart = [vox1(v).params(2),vox1(v).params(1)];
    XYend = [vox2(v).params(2),vox2(v).params(1)];
    
    XYshift = XYend-XYstart;
    angles(v) = rad2deg(atan2(XYshift(2),XYshift(1)));
    lengths(v) = sqrt(XYshift(1).^2+XYshift(2).^2);
    
    if pdist2(XYstart,center) < pdist2(XYend,center)
        sign(v) = 1;  color = 'b';
    else
        sign(v) = -1;   color = 'r';
    end
    if ~exist('plotOff','var');
        cmap = flipud(cmapang); % to account for our inverted axis
        cBin = ceil(angles(v)/360*length(cmap));
        a = arrow(XYstart,XYend,...
            'EdgeColor',color,'FaceColor',color);
        arrow(a,'Length',5,'EdgeAlpha',.25);
    end
end
if ~exist('plotOff','var');
    set(gca,'Visible','off'); hline(res/2,'k--'); vline(res/2,'k--');
    axis([.5 res+.5 .5 res+.5]); axis square;
end
end

