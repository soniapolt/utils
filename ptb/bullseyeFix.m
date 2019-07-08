function bullseyeFix(win,xc, yc, fixRad, outerPixels, dotColor, alpha,littleDot)
% bullseye-style fixation point - ptb dependent

if ~exist('alpha','var') alpha = 1; end
if ~exist('littleDot','var') littleDot = 3; end

Screen('FrameOval',win,[0 0 0],[xc-fixRad yc-fixRad xc+fixRad yc+fixRad],outerPixels,outerPixels); % outerfixation ring
Screen('FillOval', win,[255 255 255 255*alpha], [xc-fixRad+outerPixels yc-fixRad+outerPixels xc+fixRad-outerPixels yc+fixRad-outerPixels]); % white fixation disk
%Screen('FillOval', win,[dotColor 255*alpha], [xc-littleDot yc-littleDot xc+littleDot yc+littleDot]); % little fixation dot
Screen('FillOval', win,[dotColor], [xc-littleDot yc-littleDot xc+littleDot yc+littleDot]); % little fixation dot

end

